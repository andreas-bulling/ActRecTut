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

% turn debugging on
dbstop if error

% save warnings
warnings = warning;

% add paths
if ~isdeployed
    addpath(genpath('.'));
    warning('off', 'MATLAB:dispatcher:pathWarning');
    % this requires libSVM to be installed in $ROOT/Libraries/libsvm-3.1
    addpath(genpath('Libraries/libsvm-3.1/matlab/'));
    % this requires libSVM to be installed in $ROOT/Libraries/liblinear-1.8
    addpath(genpath('Libraries/liblinear-1.8/matlab/'));
    % this requires SVMlight to be installed in $ROOT/Libraries/svm-lite
    addpath(genpath('Libraries/svm-lite/'));
    % this requires mRMR to be installed in $ROOT/Libraries/mRMR_0.9_compiled
    addpath(genpath('Libraries/mRMR_0.9_compiled/'));
    % this requires jointboosting to be installed in $ROOT/Libraries/jointboosting
    addpath('Libraries/jointboosting/');
    % this requires Kevin Murphy's HMM toolbox to be installed in $ROOT/Libraries/HMMall
    asd123 = warning('off', 'MATLAB:dispatcher:nameConflict');
    addpath(genpath('Libraries/HMMall/'));
    warning(asd123)

    SETTINGS.PATH_DATA = 'Data';
    SETTINGS.PATH_OUTPUT = 'Output';
else
    SETTINGS.PATH_DATA = '/BS/blanke-projects/work/puc2010/rep/code/Data';
    SETTINGS.PATH_OUTPUT= '/BS/blanke-projects/work/puc2010/rep/code/Output';
end
SETTINGS.PATH_OUTPUT_FEATURES = [SETTINGS.PATH_OUTPUT '/features'];
    
SETTINGS.SAMPLINGRATE = 32; % sampling rate

SETTINGS.SUBJECT = 2; % which subject to use, possible values: 1, 2
SETTINGS.SUBJECT_TOTAL = 2; % total number of subjects
SETTINGS.ONEVSALL = [];
SETTINGS.DATASET = 'gesture'; % which dataset to use, possible values: walk, gesture
switch SETTINGS.DATASET
    case 'gesture'
        SETTINGS.CLASSLABELS = {'NULL', 'Open window', 'Drink', 'Water plant', 'Close window', 'Cut', 'Chop', 'Stir', 'Book', 'Forehand', 'Backhand', 'Smash'};
        SETTINGS.SENSOR_PLACEMENT = {'Right hand', 'Right lower arm', 'Right upper arm'};
        SETTINGS.CLASSES = size(SETTINGS.CLASSLABELS, 2); % number of classes
        SETTINGS.FOLDS = 26; % number of folds
        SETTINGS.SENSORS_AVAILABLE = {'acc_1_x', 'acc_1_y', 'acc_1_z', ...
                                      'gyr_1_x', 'gyr_1_y', ...
                                      'acc_2_x', 'acc_2_y', 'acc_2_z', ...
                                      'gyr_2_x', 'gyr_2_y', ...
                                      'acc_3_x', 'acc_3_y', 'acc_3_z', ...
                                      'gyr_3_x', 'gyr_3_y'}; % sensors available, one entry for each column of the data matrix
        SETTINGS.SENSORS_USED = {'acc_1', 'acc_2', 'acc_3', 'gyr_1', 'gyr_2', 'gyr_3'}; % sensors to use
        
    case 'walk'
        SETTINGS.CLASSLABELS = {'NULL', 'sitting', 'standing', 'walk horizontal', 'walk down', 'walk up'};
        SETTINGS.SENSOR_PLACEMENT = {'Right hip', 'Right lower arm', 'Right ankle', 'Upper right leg'};
        SETTINGS.CLASSES = size(SETTINGS.CLASSLABELS, 2); % number of classes
        SETTINGS.FOLDS = 4; % number of folds
        SETTINGS.SENSORS_AVAILABLE = {'acc_1_x', 'acc_1_y', 'acc_1_z', ...
                                      'gyr_1_x', 'gyr_1_y', ...
                                      'acc_2_x', 'acc_2_y', 'acc_2_z', ...
                                      'gyr_2_x', 'gyr_2_y', ...
                                      'acc_3_x', 'acc_3_y', 'acc_3_z', ...
                                      'gyr_3_x', 'gyr_3_y', ...
                                      'acc_4_x', 'acc_4_y', 'acc_4_z', ...
                                      'gyr_4_x', 'gyr_4_y'}; % sensors available, one entry for each column of the data matrix
        SETTINGS.SENSORS_USED = {'acc_1', 'acc_2', 'acc_3', 'acc_4', 'gyr_1', 'gyr_2', 'gyr_3', 'gyr_4'}; % sensors to use
end

SETTINGS.SEGMENTATION_TECHNIQUE = 'SlidingWindow'; % segmentation technique, possible values: SlidingWindow, Rest, Energy
SETTINGS.SEGMENTATION_OPTIONS.threshold = 10; % segmentation options
SETTINGS.FEATURE_TYPE = 'VerySimple'; % type of features to calculate, possible values: Raw, VerySimple, Simple, FFT, All
SETTINGS.W_SIZE_SECOND = 1; % window size for feature calculation in seconds
SETTINGS.W_STEP_SECOND = 0.1; % step size for feature calculation in seconds
SETTINGS.PLOT = 0; % (de)activate plotting
SETTINGS.SAVE = 1; % (de)activate saving of calculated features
SETTINGS.VERBOSE_LEVEL = 1; % verbose level for debug messages, possible values: 0 (quiet), 1 (results), 2 (processing steps)

SETTINGS.FEATURE_SELECTION = 'none'; % feature selection method to use, possible values: none, mRMR, SFS, SBS
SETTINGS.FEATURE_SELECTION_OPTIONS = 10; % number of features to select

SETTINGS.FUSION_TYPE = 'early'; % 'early' (i.e. feature-level) or 'late' (i.e. classifier-level) data fusion
SETTINGS.CLASSIFIER = 'knnVoting'; % classifier to use, possible values: knnVoting, NaiveBayes, SVM, liblinear, SVMlight, DA, cHMM, jointboosting
SETTINGS = setClassifier(SETTINGS.CLASSIFIER, SETTINGS);

SETTINGS.EVALUATION = 'pd'; % type of evaluation, possible values: pd (person-dependent), pi (person-independent, leave-one-person-out), loio (leave-one-instance-out)
SETTINGS.ADAPTIVE_SAMPLES = 0; % ???
SETTINGS.REDUCTION_TRAINDATA = 0; % ???

% Print summary of settings
if SETTINGS.VERBOSE_LEVEL >= 2
    prettyPrintSettings(SETTINGS)
end