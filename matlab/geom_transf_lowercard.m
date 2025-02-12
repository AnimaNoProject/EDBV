function [ card_one_corrected ] = geom_transf_lowercard( card_first, card_one )
%GEOM_TRANSF_CARD - transforms the lower card from perspective projection to
%orthographic projection
%   Author: Miran Jank, 1526438
%   Input: lower card without perspective correction
%   Output: lower card transformed

[firstcorner, secondcorner, thirdcorner, fourthcorner] = cornerDetection(card_first);

%---- Get distance of all relevant edges ----%

distOL = round(pdist([firstcorner;secondcorner],'euclidean'));
distLU = round(pdist([secondcorner;fourthcorner],'euclidean'));
distUR = round(pdist([fourthcorner;thirdcorner],'euclidean'));
distRO = round(pdist([thirdcorner;firstcorner],'euclidean'));

distarray = [distOL,distLU,distUR,distRO];


%---- Search for the shortestpath ,secondshortestpath and longestpath ----%
shortestpath = distOL;
secondshortestpath = distRO;
longestpath = distOL;

for i = 1:4
    if(distarray(i) < shortestpath)
        shortestpath = distarray(i);
    end
    if(distarray(i) > longestpath)
        longestpath = distarray(i);
    end
end

TEMP = 50000;
for i = 1:4
    if(distarray(i) == shortestpath)
    elseif((distarray(i) - shortestpath) < TEMP)
        secondshortestpath = distarray(i);
        TEMP = distarray(i) - shortestpath;
    end
end

%---- Corner creation and allocation ----%
%Create new corner
newcorner = [0 0];

%Calculate coordinates of the new corner
if(longestpath == distOL)
    if(shortestpath == distRO || secondshortestpath == distRO)
        %left(secondcorner) is to be changed
        
        newcorner = firstcorner - secondcorner;
        betragnewcorner = norm(newcorner);
        einheitsvektor = newcorner/betragnewcorner;
        einheitsvektor = einheitsvektor * (longestpath - shortestpath);
        newcorner = secondcorner + einheitsvektor;
        
        secondcorner = newcorner;
    elseif(shortestpath == distLU || secondshortestpath == distLU)
        %up(firstcorner)
        %180° WORKS
        newcorner = secondcorner - firstcorner;
        betragnewcorner = norm(newcorner);
        einheitsvektor = newcorner/betragnewcorner;
        einheitsvektor = einheitsvektor * (longestpath - shortestpath);
        newcorner = firstcorner + einheitsvektor;
        
        firstcorner = newcorner;
    end
elseif(longestpath == distRO)
    if(shortestpath == distOL || secondshortestpath == distOL)
        %right(thirdcorner)
        %270° SEMIWORKS - verzerrung, da gedreht
        newcorner = firstcorner - thirdcorner;
        betragnewcorner = norm(newcorner);
        einheitsvektor = newcorner/betragnewcorner;
        einheitsvektor = einheitsvektor * (longestpath - shortestpath);
        newcorner = thirdcorner + einheitsvektor;
        
        thirdcorner = newcorner;
    elseif(shortestpath == distUR || secondshortestpath == distUR)
        %up(firstcorner)
        %
        newcorner = thirdcorner - firstcorner;
        betragnewcorner = norm(newcorner);
        einheitsvektor = newcorner/betragnewcorner;
        einheitsvektor = einheitsvektor * (longestpath - shortestpath);
        newcorner = firstcorner + einheitsvektor;
        
        firstcorner = newcorner;
    end
elseif(longestpath == distLU)
    if(shortestpath == distOL || secondshortestpath == distOL)
        %down(fourthcorner)
        %
        newcorner = secondcorner - fourthcorner;
        betragnewcorner = norm(newcorner);
        einheitsvektor = newcorner/betragnewcorner;
        einheitsvektor = einheitsvektor / (longestpath - shortestpath);
        newcorner =  fourthcorner + einheitsvektor;
        
        fourthcorner = newcorner;
    elseif(shortestpath == distUR || secondshortestpath == distUR)
        %left(secondcorner)
        %90° SEMIWORKS - verzerrung, da gedreht
        newcorner = fourthcorner - secondcorner;
        betragnewcorner = norm(newcorner);
        einheitsvektor = newcorner/betragnewcorner;
        einheitsvektor = einheitsvektor * (longestpath - shortestpath);
        newcorner = secondcorner + einheitsvektor;
        
        secondcorner = newcorner;
    end
elseif(longestpath == distUR)
    if(shortestpath == distRO || secondshortestpath == distRO)
        %down(fourthcorner)
        %0° WORKS
        newcorner = thirdcorner - fourthcorner;
        betragnewcorner = norm(newcorner);
        einheitsvektor = newcorner/betragnewcorner;
        einheitsvektor = einheitsvektor * (longestpath - shortestpath);
        newcorner = fourthcorner + einheitsvektor;
        
        fourthcorner = newcorner;
    elseif(shortestpath == distLU || secondshortestpath == distLU)
        %right(thirdcorner)
        %
        newcorner = fourthcorner - thirdcorner;
        betragnewcorner = norm(newcorner);
        einheitsvektor = newcorner/betragnewcorner;
        einheitsvektor = einheitsvektor * (longestpath - shortestpath);
        newcorner = thirdcorner + einheitsvektor;
        
        thirdcorner = newcorner;
    end
end

corners = [firstcorner;secondcorner;thirdcorner;fourthcorner];

r = [corners(1,1) corners(2,1) corners(3,1) corners(4,1)]';
c = [corners(1,2) corners(2,2) corners(3,2) corners(4,2)]';
% Verhältnis zwischen der linken und rechten Seite
links = [firstcorner; secondcorner];
rechts = [thirdcorner; fourthcorner];
d_l = pdist(links,'euclidean');
d_r = pdist(rechts,'euclidean');

% Kartenverhältnis 5:8 normal - 5:4 bei halber Karte
base = [0 0; 0 4; 5 0; 5 4*(d_r/d_l)]*150;
% Tansformation-Matrix 
movPts = [c r];
fixPts = base;
tform = getTransformationMatrix(movPts',fixPts');

% In double umwandeln
card_one = double(card_one);     
card_one = card_one/255;  

% RGB-Kanäle einzeln transformieren
[r] = geotransform(card_one(:,:,1), tform);
[g] = geotransform(card_one(:,:,2), tform);
[b] = geotransform(card_one(:,:,3), tform);

% Output erzeugen und Kanäle zusammenlegen
card_one_corrected = repmat(uint8(0),[size(r),3]);
card_one_corrected(:,:,1) = uint8(round(r*255));
card_one_corrected(:,:,2) = uint8(round(g*255));
card_one_corrected(:,:,3) = uint8(round(b*255));
end

