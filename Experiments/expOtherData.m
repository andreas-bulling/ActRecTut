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

% Adapt to other dataset
SETTINGS.DATASET = 'dailyroutine'; 
SETTINGS.CLASSLABELS = {'NULL', 'dinner activities', 'commuting', 'lunch routine', 'office work'};
SETTINGS.SENSOR_PLACEMENT = {'Right Pocket', 'Right Wrist'};
SETTINGS.CLASSES = size(SETTINGS.CLASSLABELS, 2); % number of classes
SETTINGS.FOLDS = 7; % number of folds
SETTINGS.SENSORS_AVAILABLE = {'accm_1_x', 'accm_1_y', 'accm_1_z', ...
                              'accv_1_x', 'accv_1_y', 'accv_1_z', ...
                              'accm_2_x', 'accm_2_y', 'accm_2_z', ...
                              'accv_2_x', 'accv_2_y', 'accv_2_z', 'timestamp'}; % sensors available, one entry for each column of the data matrix
SETTINGS.SENSORS_USED = {'accm_1', 'accv_1', 'accm_2', 'accv_2'}; % sensors to use
        
SETTINGS.EVALUATION = 'customfolds';
SETTINGS.W_SIZE_SECOND = 60*15; % 30 min
SETTINGS.W_STEP_SECOND = 60*30/10; % 15 min
SETTINGS.SAMPLINGRATE = 2;
SETTINGS.PLOT = 1; 
% set the folds
loc = 'Data/dailyroutines';
for day = 1:7   
    foldsData{day}  = sprintf('%s/day%d-data.txt', loc, day);
    foldsLabels{day} = sprintf('%s/day%d-routines.txt', loc, day);
end
% set experiment specific settings
SETTINGS = setClassifier('knnVoting', SETTINGS);
SETTINGS.VERBOSE_LEVEL = 2;
EXPERIMENT_NAME = 'Routines';
IDENTIFIER_NAME = 'simple_routines';

% review settings
prettyPrintSettings(SETTINGS)
response = input('Press ENTER as soon as you have finished reviewing the settings.');

% CHANGES HERE:
% preprocessing
fprintf('\nPreprocessing ...');
[features fType fDescr segments segmentation...
    labelsSegmentation featureLabels SETTINGS]...
    = prepareFoldData(SETTINGS, 'foldLabelsFileLocation', foldsLabels, 'foldDataFileLocation', foldsData);

% evaluate
fprintf('\nEvaluation ...');
[confusion, metrics, scoreEval] = run_evaluation(features, fType, fDescr, segments, segmentation, labelsSegmentation, featureLabels, SETTINGS);

% save experiment result
filename = saveExperiment(confusion, metrics, scoreEval, EXPERIMENT_NAME, IDENTIFIER_NAME, SETTINGS);