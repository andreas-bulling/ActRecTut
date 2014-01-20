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

SETTINGS = setClassifier('knnVoting', SETTINGS);

% INDEPENDENT
clear result;
SETTINGS.EVALUATION = 'pi';
[features fType fDescr segments segmentation labelsSegmentation SETTINGS] = prepareFoldData(SETTINGS);

% evaluate
[confusion, metrics, scoreEval] = run_evaluation(features, fType, fDescr, segments, segmentation, labelsSegmentation, featureLabels, SETTINGS);

% store results
filename = saveExperiment(confusion, metrics, scoreEval, 'personindependence', 'independent', SETTINGS);

% DEPENDENT (not averaged)
clear result;
SETTINGS.EVALUATION = 'pd';
scoreEvalAverage = [];
msetAverage = mset_empty(SETTINGS.CLASSES);
confusionAverage = [];

for iSubject = 1:SETTINGS.SUBJECT_TOTAL
    SETTINGS.SUBJECT = iSubject;    
    [features fType fDescr segments segmentation labelsSegmentation SETTINGS] = prepareFoldData(SETTINGS);
    
    % evaluate
    [confusion, metrics, scoreEval] = run_evaluation(features, fType, fDescr, segments, segmentation, labelsSegmentation, featureLabels, SETTINGS);
    
    % store results
    filename = saveExperiment(confusion, metrics, scoreEval, 'personindependence', ['dependent' num2str(iSubject)], SETTINGS);
    
    confusionAverage = confusionAverage + confusion;
    msetAverage = mset_add(msetAverage, metrics.t.mset);
    scoreEvalAverage = scoreEvalAverage + scoreEvalAverage;
end

% DEPENDENT (averaged)
filename = saveExperiment(confusionAverage, mset_metrics(msetAverage), scoreEvalAverage, 'personindependence', 'dependentaveraged', SETTINGS);