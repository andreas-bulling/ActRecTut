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

function prettyPrintSettings(SETTINGS)

fprintf('\nSUMMARY OF SETTINGS\n')
fprintf('------------------------\n')

fprintf('Sampling rate: %iHz\n', SETTINGS.SAMPLINGRATE);
fprintf('Dataset: %s\n', SETTINGS.DATASET);
fprintf('Participant: %i/%i\n', SETTINGS.SUBJECT, SETTINGS.SUBJECT_TOTAL);
fprintf('Sensor placements: %s\n', print_cell(SETTINGS.SENSOR_PLACEMENT, 1));
fprintf('Sensors (with # of axes):%s\n', print_cell(SETTINGS.SENSORS_AVAILABLE, 0));
fprintf('Sensors used: %s\n', print_cell(SETTINGS.SENSORS_USED, 0));
fprintf('Class labels: %s\n', print_cell(SETTINGS.CLASSLABELS, 1));
fprintf('Segmentation: %s\n', SETTINGS.SEGMENTATION_TECHNIQUE);
fprintf('Features: %s\n', SETTINGS.FEATURE_TYPE);
fprintf('Window/step size: %1.2fs / %1.2fs\n', SETTINGS.W_SIZE_SECOND, SETTINGS.W_STEP_SECOND);
fprintf('Feature Selection: %s\n', SETTINGS.FEATURE_SELECTION);
fprintf('Classifier: %s\n', SETTINGS.CLASSIFIER);
fprintf('Classifier Options (Training): %s\n', print_cell(SETTINGS.CLASSIFIER_OPTIONS.training, 0));
fprintf('Classifier Options (Testing): %s\n', print_cell(SETTINGS.CLASSIFIER_OPTIONS.testing, 0));
fprintf('Evaluation: %s\n', evalAbbrToFull(SETTINGS.EVALUATION));
fprintf('Folds: %i\n', SETTINGS.FOLDS);
fprintf('Fusion type: %s\n', SETTINGS.FUSION_TYPE);
fprintf('Verbose level: %i\n\n', SETTINGS.VERBOSE_LEVEL);