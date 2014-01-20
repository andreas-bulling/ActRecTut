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
SETTINGS.W_STEP_SECOND = 0.05; % fixed
WINDOWSIZES = [0.1 0.25 0.5 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0];

clear result;
for iWS = 1:length(WINDOWSIZES)
    fprintf('\nRUNNING EVALUATION FOR window size %1.2f\n', WINDOWSIZES(iWS))
    SETTINGS.W_SIZE_SECOND = WINDOWSIZES(iWS);
    result.(['ws_' num2str(iWS)]) = [];

    % preprocess
 [features fType fDescr segments segmentation labelsSegmentation featureLabels SETTINGS]  = prepareFoldData(SETTINGS);
    %[features fType fDescr segments segmentation labelsSegmentation] = run_preprocess(dataAll, labelsAll, segmentsAll, SETTINGS);
    
    % evaluate
    [confusion, metrics, scoreEval] = run_evaluation(features, fType, fDescr, segments, segmentation, labelsSegmentation, featureLabels, SETTINGS);

    % store results
    result.(['ws_' num2str(iWS)]).confusion = confusion;
    result.(['ws_' num2str(iWS)]).metrics = metrics;
    result.(['ws_' num2str(iWS)]).scoreEval = scoreEval;

   filename = saveExperiment(confusion, metrics, scoreEval, 'windowsizes', WINDOWSIZES(iWS), SETTINGS);
end

% plot
plotEvaluationResults(result, SETTINGS, 'RPC');