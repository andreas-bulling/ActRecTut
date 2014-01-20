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

function [features fType fDescr segments segmentation labelsSegmentation, featureLabels] = run_preprocess(dataAll, labelsAll, segmentsAll, SETTINGS)

% (1) Preprocessing
% (1.1) Split data set into repetitions
[data labels segments nRepetitions] = splitIntoRepetitions(dataAll, labelsAll, segmentsAll);

% (1.2) Calculate label statistics
stats = calculateLabelStatistics(cell2mat(segments(:)));
if SETTINGS.PLOT
    prettyPrintStats(stats, SETTINGS.CLASSLABELS);
end

features = cell(0);
segmentation = cell(0);
labelsSegmentationRepetition = cell(0);

% Loop over repetitions
for i = 1:nRepetitions
    if SETTINGS.VERBOSE_LEVEL >= 2
        fprintf('\nREPETITION %i/%i\n', i, nRepetitions);
    else
        fprintf('.');
    end
    
    % (2) Segmentation
    segmentation{i} = segment(data{i}, 'method', SETTINGS.SEGMENTATION_TECHNIQUE, 'options', SETTINGS.SEGMENTATION_OPTIONS, ...
        'samplingrate', SETTINGS.SAMPLINGRATE, 'windowsize', SETTINGS.W_SIZE_SECOND, 'stepsize', SETTINGS.W_STEP_SECOND, 'verbose', SETTINGS.VERBOSE_LEVEL);
    labelsSegmentation = assignLabels(segments{i}, segmentation{i});
    
    % Sensor selection
    data{i} = selectSensorData(data{i}, 'sensorsAvailable', SETTINGS.SENSORS_AVAILABLE, 'sensorsUsed', SETTINGS.SENSORS_USED, ...
        'fusion', SETTINGS.FUSION_TYPE, 'verbose', SETTINGS.VERBOSE_LEVEL);
    
    % (3) Feature extraction    
    [features{i,1} fType fDescr] = feature_extraction(data{i}, segmentation{i}, 'featureType', SETTINGS.FEATURE_TYPE, 'verbose', SETTINGS.VERBOSE_LEVEL);
    labelsSegmentationRepetition{i,1} = labelsSegmentation;
end

labelsSegmentation = labelsSegmentationRepetition;

% Generate feature labels
featureLabels = generateFeatureLabels(fDescr, SETTINGS);

% Save variables
if SETTINGS.SAVE
    savename = sprintf('%s/features_dataset%s_subject%d---wSize=%2.2f_wStep=%2.2f_Feature=%s.mat',...
        SETTINGS.PATH_OUTPUT_FEATURES, SETTINGS.DATASET, SETTINGS.SUBJECT, SETTINGS.W_SIZE_SECOND, SETTINGS.W_STEP_SECOND, SETTINGS.FEATURE_TYPE);
    
    fprintf('\nSaving %s\n', savename);
    
    if ~exist(SETTINGS.PATH_OUTPUT_FEATURES, 'dir')
        mkdir(SETTINGS.PATH_OUTPUT_FEATURES);
    end
    save(savename, 'features', 'fType', 'fDescr', 'segments', 'segmentation', 'labelsSegmentation', 'featureLabels', 'SETTINGS');
end

if SETTINGS.PLOT  
    % Visualize data
    %{
    p=1;
    dim = size(dataAll, 2);
    nSensorTypes =length(SETTINGS.SENSORS_USED);
    for i = 1:6:dim
        X = dataAll(:, i:i+5);
        figure;        
        for s=0:nSensorTypes-1
            Xsensor = X(:, s*3+1:3*(s+1));
            subplot(nSensorTypes, 1, s+1);
            illustrateLabelsEfficient(labelSegments(:, [1 2 4]), 0, -1, min(min(Xsensor)), max(max(Xsensor)));
            hold all;
            plot(Xsensor);
            title(sprintf('%s %s', sensorType{s+1}, placement{p})); 
        end  
        p=p+1;
    end

    % Visualize features
    figure;
    
    for f = 1:length(fDescr)
        subplot(length(fDescr)+1, 1, f);
        imagesc(features(:, fType==f)');
        set(gca,'YTick', 1:nSensorTypes*nSensors:dim);
        set(gca,'YTicklabel', placement);
        title(fDescr{f});
    end
    subplot(length(fDescr)+1, 1, length(fDescr)+1);
    illustrateLabelsEfficient(labelSegments(:, [1 2 4]), 0, -1);
    xlim([0 max(segmentation(:, 2))]);
    %}
end