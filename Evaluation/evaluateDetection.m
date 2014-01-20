% evaluateDetection
% takes label segments and segments from segmentation attached to scores
% returns relevant evaluation metrics
% can get expensive, for a lot of segments (especially, for bad peroformance)
% 
% Copyright 2011-2014 Ulf Blanke, Swiss Federal Institute of Technology (ETH) Zurich, Switzerland
% Copyright 2011-2014 Andreas Bulling, Max Planck Institute for Informatics, Germany
%
% --------------------------------------------------------------------
% This file is part of the ActRecTut Matlab toolbox.
%
% ActRecTut is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% ActRecTut is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with HARPS. If not, see <http://www.gnu.org/licenses/>.
% --------------------------------------------------------------------

function [precisions recalls fallouts accuracys] = evaluateDetection(labelSegments, segments, scores, class)  
    THRESHOLD_PRECISION = 0.5;
    THRESHOLD_RECALL = 0.5;
    scores = scores(:,class);
    scoresSteps = unique(scores); % make it more efficient
    scoresSteps = sort(scoresSteps,'descend');    
    
    groundtruth = labelSegments(labelSegments(:,4)==class,:);

    precisions(1:length(scoresSteps)) = 0;
    recalls(1:length(scoresSteps)) = 0;
    fallouts(1:length(scoresSteps)) = 1;
    accuracys(1:length(scoresSteps)) = 0;

    P = sum(groundtruth); % N cannot be calculated

    for i=1:length(scoresSteps)

        ix = scores>=scoresSteps(i);     
        detections = segments(ix,:);
        hits =  hitsEventCriterion(groundtruth, detections);
        % hits = hitsPascalCriterion(groundtruth, detections); 
        % Pascal Criterion
        TP = sum(hits>=1);  % label and (multiple) detection      
        FN = sum(hits==0); % label and no detection
        FP = sum(hits>1) + size(detections,1) - TP; % multi-hits + detection and no label - good hits
   %    FP = size(detections,1) - TP; % detections - true positives
%{
        illustrateLabelsEfficient(groundtruth(:,[1 2 4]),0,1,0,0.01);
        line([detections(:,1) detections(:,2)]',[scoresSorted(ix) scoresSorted(ix)]','color',[0 0 0], 'LineWidth',8);
%}
        TN = length(detections)-TP+FP;  % usually very high for detection tasks:
                                        % therefore accuracy of 90% can be
                                        % look good but is crappy
        precisions(i) = TP/(TP+FP);     % or positive predictive value
        recalls(i) = TP/(TP+FN);        % or true positive rate, hit rate, sensitivity
        fallouts(i) = FP/(FP+TN);       % false positive rate
        accuracys(i) = (TP+TN)/(TP+TN+FP+FN);  

        if ((precisions(i) < THRESHOLD_PRECISION)...
                && (recalls(i) > THRESHOLD_RECALL))    % give up
            recalls(i:end) = recalls(i);            
            return;
        end
       
    end    
