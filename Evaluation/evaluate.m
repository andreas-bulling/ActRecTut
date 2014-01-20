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

function [precisions recalls fallouts accuracys] = evaluate(labels, scores, class)  
    % TODO: double check this for errors :) and make it more modular
    % (integrating confusion matrix here too)
    % Note: do not run over all (lower) thresholds, takes too much time and is not
    % necessarily sensible
    THRESHOLD_PRECISION = 0.5;
    THRESHOLD_RECALL = 0.5;
    scores = scores(:,class);
    scoresSteps = unique(scores); % make it more efficient
    scoresSteps = sort(scoresSteps,'descend');    
    %sortedScores = sortedScores(sortedScores>THRESHOLD);
    groundtruth = labels==class;
   
    precisions(1:length(scoresSteps)) = 0;
    recalls(1:length(scoresSteps)) = 0;
    fallouts(1:length(scoresSteps)) = 1;
    accuracys(1:length(scoresSteps)) = 0;
    
    %P = sum(groundtruth);
    %N = sum(~groundtruth);
    for i=1:length(scoresSteps)
        
        detections = scores>=scoresSteps(i);        
        TP = sum(groundtruth&detections);  % groundtruth and detection      
        FN = sum(groundtruth&~detections); % groundtruth and no detection
        FP = sum(detections-(groundtruth&detections));
        TN = sum(~groundtruth&~detections);
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
end