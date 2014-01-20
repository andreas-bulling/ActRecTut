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

% load default settings
settings;

% set experiment specific settings
SETTINGS = setClassifier('knnVoting', SETTINGS);
SETTINGS.VERBOSE_LEVEL = 2;
SETTINGS.SENSORS_USED = {'acc_1'};
SETTINGS.PLOT = 1
EXPERIMENT_NAME = 'tutorial';
IDENTIFIER_NAME = 'knn_acc_1';

% review settings
prettyPrintSettings(SETTINGS)
response = input('Press ENTER as soon as you have finished reviewing the settings.');

% preprocessing
fprintf('\nPreprocessing ...');
[features fType fDescr segments segmentation labelsSegmentation featureLabels SETTINGS] = prepareFoldData(SETTINGS);

% evaluate
fprintf('\nEvaluation ...');
[confusion, metrics, scoreEval] = run_evaluation(features, fType, fDescr, segments, segmentation, labelsSegmentation, featureLabels, SETTINGS);

% save experiment result
filename = saveExperiment(confusion, metrics, scoreEval, EXPERIMENT_NAME, IDENTIFIER_NAME, SETTINGS);