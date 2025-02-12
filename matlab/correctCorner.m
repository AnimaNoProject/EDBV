function [correctCorners] = correctCorner(corner1, corner2, corner3, corner4)
%   Author: Jan Michael Laranjo
%   Detailed explanation:
%   INPUT:
%       corner1         --> represents the first corner
%       corner1         --> represents the second corner
%       corner1         --> represents the third corner
%       corner1         --> represents the fourth corner
%   OUTPUT:
%       correctCorners  --> vector containing every correct corner of the
%       card. For instance the bottom card can have wrong corner due to
%       overlapping with the top card and it can have wrong corners. This
%       method returns the correct detected corners.
%
correctCorners = [];
if(isCorrectEdge(corner1, [corner2;corner3;corner4]))
    correctCorners = getCorrectCorners(corner1, [corner2;corner3;corner4]);
elseif(isCorrectEdge(corner2, [corner1;corner3;corner4]))
    correctCorners = getCorrectCorners(corner2, [corner1;corner3;corner4]);
elseif(isCorrectEdge(corner3, [corner1;corner2;corner4]))
    correctCorners = getCorrectCorners(corner3, [corner1;corner2;corner4]);
elseif(isCorrectEdge(corner4, [corner1;corner2;corner3]))
    correctCorners = getCorrectCorners(corner4, [corner1;corner2;corner3]);
end
end

function [isCorrectEdge] = isCorrectEdge(currentCorner, corners)
%   Author: Jan Michael Laranjo
%   Detailed explanation:
%   INPUT:
%       currentCorner   --> represents the corner to be examined
%       corners         --> vectors of every other corners of the card
%   OUTPUT:
%       isCorrectEdge   --> is the flag if the card is a correct corner.
%       This can be determined by the ratio of the card. The card has to
%       have the correct ratio of 5:8 and if a wrong corner is declared as
%       correct, the card would have a wrong ratio, thus this corner is
%       wrong.
%   determines if the edge is a correct corner
    u = norm(corners(1,:) - currentCorner);
    v = norm(corners(2,:) - currentCorner);
    w = norm(corners(3,:) - currentCorner);
    isRatio1 = isRatioCorrect(u,v);
    isRatio2 = isRatioCorrect(u,w);
    isRatio3 = isRatioCorrect(v,w);
    if(isRatio1 || isRatio2 || isRatio3)
        isCorrectEdge = 1;
    else
        isCorrectEdge = 0;
    end
end

% u > v && u:v = 5:8
function [isRatioCorrect] = isRatioCorrect(u, v)
%   Author: Jan Michael Laranjo
%   Detailed explanation:
%   INPUT:
%       u               --> first edge adjacent to the corner to be examined
%       v               --> second edge adjacent to the corner to be examined
%   OUTPUT:
%       isRatioCorrect  --> is true if the edges adjacent to the card have
%       the correct ratio of 5:8
%   check if the edges have the correct ratio of 5:8
    ratio = (8 * u) / (5 * v);
    threshold = 0.3;
    if((ratio > (1 - threshold)) && (ratio < (1 + threshold)))
        isRatioCorrect = 1;
    else
        isRatioCorrect = 0;
    end
end

function[correctCorners] = getCorrectCorners(currentCorner, corners)
%   Author: Jan Michael Laranjo
%   Detailed explanation:
%   INPUT:
%       currentCorner   --> represents the corner to be examined
%       corners         --> vectors of every other corners of the card
%   OUTPUT:
%       correctCorners  --> vectors of the correctCorners
%   returns the correct corners of the card. The wrong dected corners get
%   discarded
    u = norm(corners(1,:) - currentCorner);
    v = norm(corners(2,:) - currentCorner);
    w = norm(corners(3,:) - currentCorner);
    if(isRatioCorrect(u,v)) 
        correctCorners = [currentCorner;corners(1,:);corners(2,:)];
    elseif (isRatioCorrect(u,w))
        correctCorners = [currentCorner;corners(1,:);corners(3,:)];
    elseif(isRatioCorrect(v,w))     
        correctCorners = [currentCorner;corners(2,:);corners(3,:)];
    end
end