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
SETTINGS.FEATURE_TYPE = 'VerySimple';
SETTINGS.FEATURE_SELECTION = 'mRMR';
NFEATURES = 1:36;

fprintf('\nPreprocessing ');
 [features fType fDescr segments segmentation labelsSegmentation featureLabels SETTINGS]  = prepareFoldData(SETTINGS);
%[features fType fDescr segments segmentation labelsSegmentation] = run_preprocess(dataAll, labelsAll, segmentsAll, SETTINGS);

clear result;
for iFeature = NFEATURES
    fprintf('\nRUNNING EVALUATION FOR %i features\n', iFeature);
    SETTINGS.FEATURE_SELECTION_OPTIONS = iFeature;
    result.(['nfeatures_' num2str(iFeature)]) = [];

    % evaluate
    [confusion, metrics, scoreEval] = run_evaluation(features, fType, fDescr, segments, segmentation, labelsSegmentation, featureLabels, SETTINGS);

    % store results
    result.(['nfeatures_' num2str(iFeature)]).confusion = confusion;
    result.(['nfeatures_' num2str(iFeature)]).metrics = metrics;
    result.(['nfeatures_' num2str(iFeature)]).scoreEval = scoreEval;

   filename = saveExperiment(confusion, metrics, scoreEval, 'nfeatures', iFeature, SETTINGS);
end

% plot
plotEvaluationResults(result, SETTINGS, 'RPC');