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

clear all
settings;
close all;
PLOT = 1;

%rankMatrix = zeros(length(featureLabels), SETTINGS.FOLDS); % 300 features, 26 folds
rankMatrix = zeros(150, SETTINGS.FOLDS); % 300 features, 26 folds

%% analyse feature ranking over all classes
if 1
    evaluations = {'pd'}; %, 'pi'};
    featureSetSizes = [1 5 10 20 25 30 40 50 100 150];
    
    for iEvaluation = evaluations
        for iSubject = 1:SETTINGS.SUBJECT_TOTAL
            loadname = [SETTINGS.PATH_OUTPUT '/experiments/expStudy_4_1_2_feature_selection_sweepset/pd300mRMR_subject' num2str(iSubject) '_' SETTINGS.DATASET];
            load(loadname)

            for i = 1:length(featureSetSizes)
                placementMatrix{iSubject}{i} = zeros(length(SETTINGS.SENSOR_PLACEMENT), 1);
            end

            % create rank matrix (rows: features, columns: folds)
            % => each non-zero entry of the matrix contains the rank of that
            % feature (row) for a specific fold (column)
            for iFold = 1:SETTINGS.FOLDS
                features = fSelection{iFold};

                for idc = 1:length(features)
                    feature = features(idc);
                    rankMatrix(feature, iFold) = idc;
                end
            end

            % calculate distributions
            for iTopFeatures = 1:length(featureSetSizes)
                iTopSelect = calculateTopFeatures(rankMatrix, 'nTopFeatures', featureSetSizes(iTopFeatures));

                for iF = iTopSelect
                    placementMatrix{iSubject}{iTopFeatures}(getPlacement(featureLabels{iF}), 1) = placementMatrix{iSubject}{iTopFeatures}(getPlacement(featureLabels{iF}), 1) + 1;
                end       
            end

            % different features
            handle = plotFeatureRanking(rankMatrix, 'featureNames', featureLabels, 'plotTitle', ['Subject ' num2str(iSubject)], 'nTopFeatures', 15);
            saveas(handle, [SETTINGS.PATH_OUTPUT '/Subject' num2str(iSubject) '/featureRanking_subject' num2str(iSubject) '-' evalAbbrToFull(iEvaluation{:}) '.pdf']);
            close(handle);

            % different placements
            for iPlacement = 1:length(SETTINGS.SENSOR_PLACEMENT)
                [tempMatrix, tempLabels] = aggregateFeatureRanks(rankMatrix, featureLabels, 'type', 'placement', 'selection', iPlacement);
                % TODO: the mapping from feature number to feature name is
                % correct (i.e. the correct feature label is shown in the plot)
                % but the feature number is not (i.e. feature #10 in tempMatrix
                % does not correspond to feature #10 in rankMatrix)
                handle = plotFeatureRanking(tempMatrix, 'featureNames', tempLabels, ...
                    'plotTitle', [SETTINGS.SENSOR_PLACEMENT{iPlacement} ' (subject ' num2str(iSubject) ')'], 'nTopFeatures', 15);

                saveas(handle, [SETTINGS.PATH_OUTPUT '/Subject' num2str(iSubject) '/featureRanking_subject' num2str(iSubject) '-' evalAbbrToFull(iEvaluation{:}) '_placement_' regexprep(SETTINGS.SENSOR_PLACEMENT{iPlacement}, '[^\w'']', '_') '.pdf']);
                close(handle);
            end

            % different types of sensors (acc/gyr)
            sensors = getSensorType(SETTINGS.SENSORS_AVAILABLE);
            for iSensor = 1:length(sensors)
                [tempMatrix, tempLabels] = aggregateFeatureRanks(rankMatrix, featureLabels, 'type', 'sensor', 'selection', iSensor);
                % TODO: the mapping from feature number to feature name is
                % correct (i.e. the correct feature label is shown in the plot)
                % but the feature number is not (i.e. feature #10 in tempMatrix
                % does not correspond to feature #10 in rankMatrix)
                handle = plotFeatureRanking(tempMatrix, 'featureNames', tempLabels, ...
                    'plotTitle', [sensors{iSensor} ' (subject ' num2str(iSubject) ')'], 'nTopFeatures', 15);

                saveas(handle, [SETTINGS.PATH_OUTPUT '/Subject' num2str(iSubject) '/featureRanking_subject' num2str(iSubject) '-' evalAbbrToFull(iEvaluation{:}) '_sensor_' sensors{iSensor} '.pdf']);
                close(handle);
            end 

            for iTopFeatures = 1:length(featureSetSizes)
                placementMatrix{iSubject}{iTopFeatures} = placementMatrix{iSubject}{iTopFeatures}/featureSetSizes(iTopFeatures);
            end
        end

        % analysis
        plotMatrix = [];
        for iTopFeatures = 1:length(featureSetSizes)
            plotMatrix(:, iTopFeatures) = placementMatrix{1}{iTopFeatures}(:,1);
        end

        handle = figure;
        bar(plotMatrix', 'stack');
        title(['Subject 1 / ' evalAbbrToFull(iEvaluation{:})]);
        xlabel('Number of top features');
        ylabel('Feature distribution [%]');
        legend(SETTINGS.SENSOR_PLACEMENT);
        ylim([0 1]);
        set(gca, 'XTickLabel', featureSetSizes);
        set(gca, 'YTickLabel', 0:10:100);
        set(gca, 'YTick', 0:.1:1);
        set(gca, 'TickDir', 'out');
        grid on

        savename = [SETTINGS.PATH_OUTPUT '/topFeatureDistribution_subject1_' evalAbbrToFull(iEvaluation{:}) '.pdf'];
        saveas(handle, savename);
        close(handle);
    end
end

%% analyse feature ranking one-vs-all (each class separately)
if 0
    evaluations = {'pd'}; %, 'pi'};
    featureSetSizes = [1 5 10 20 25 30 40 50 100 150];
    classLabels = {'NULL', 'Open window', 'Drink', 'Water plant', 'Close window', 'Cut', 'Chop', 'Stir', 'Book', 'Forehand', 'Backhand', 'Smash'};

    for iEvaluation = evaluations
        for iSubject = 1:SETTINGS.SUBJECT_TOTAL
            
            if ~exist([SETTINGS.PATH_OUTPUT '/Subject' num2str(iSubject)], 'dir')
                mkdir([SETTINGS.PATH_OUTPUT '/Subject' num2str(iSubject)]);
            end
            
            for i = 1:length(featureSetSizes)
                placementMatrix{iSubject}{i} = zeros(length(SETTINGS.SENSOR_PLACEMENT), 11);
%                sensorMatrix{iSubject}{i} = zeros(length(fieldnames(SETTINGS.SENSORS_AVAILABLE)), 11);
            end
            
            for iClass = 2:12 % TODO: hardcoded!!!
                if strcmp(iEvaluation{:}, 'pd')
                    loadname = [SETTINGS.PATH_OUTPUT '/experiments/expStudy_4_1_3_feature_selection_one_vs_all100/' num2str(iClass) 'mRMR_subject' num2str(iSubject) '_' SETTINGS.DATASET];
                    savename = [SETTINGS.PATH_OUTPUT '/Subject' num2str(iSubject) '/featureRanking_' regexprep(classLabels{iClass}, '[^\w'']', '_') '_subject' num2str(iSubject) '-' evalAbbrToFull(iEvaluation{:})];
                    plotTitle = ['Subject ' num2str(iSubject) ' / Class ' classLabels{iClass} ' / ' evalAbbrToFull(iEvaluation{:})];
                else
                    loadname = [SETTINGS.PATH_OUTPUT '/experiments/expStudy_4_1_3_feature_selection_one_vs_all100/' iEvaluation{:} num2str(iClass) 'mRMR_' SETTINGS.DATASET];
                    savename = [SETTINGS.PATH_OUTPUT '/Subject' num2str(iSubject) '/featureRanking_' regexprep(classLabels{iClass}, '[^\w'']', '_') '-' evalAbbrToFull(iEvaluation{:})];
                    plotTitle = ['Class ' classLabels{iClass} ' / ' evalAbbrToFull(iEvaluation{:})];
                end
                load(loadname)

                % create rank matrix (rows: features, columns: folds)
                % => each non-zero entry of the matrix contains the rank of that
                % feature (row) for a specific fold (column)                
                if iscell(SETTINGS.FOLDS)
                    SETTINGS.FOLDS = size(SETTINGS.FOLDS,2);
                end
                
                for iFold = 1:SETTINGS.FOLDS
                    features = fSelection{iFold};

                    for idc = 1:length(features)
                        feature = features(idc);
                        rankMatrix(feature, iFold) = idc;
                    end
                end    

                % calculate distributions
                for iTopFeatures = 1:length(featureSetSizes)
                    iTopSelect = calculateTopFeatures(rankMatrix, 'nTopFeatures', featureSetSizes(iTopFeatures));
                    
                    for iF = iTopSelect
                        placementMatrix{iSubject}{iTopFeatures}(getPlacement(featureLabels{iF}), iClass-1) = placementMatrix{iSubject}{iTopFeatures}(getPlacement(featureLabels{iF}), iClass-1) + 1;
%                        sensorMatrix{iSubject}{iTopFeatures}(getSensorType(featureLabels{iF}), iClass-1) = sensorMatrix{iSubject}{iTopFeatures}(getSensorType(featureLabels{iF}), iClass-1) + 1;
                    end       
                end
                
                if PLOT
                    % different features                
                    handle = plotFeatureRanking(rankMatrix, 'featureNames', featureLabels, 'plotTitle', plotTitle, 'nTopFeatures', 15);
                    saveas(handle, [savename '.pdf']);
                    close(handle);
                    
                    % different placements
                    for iPlacement = 1:length(SETTINGS.SENSOR_PLACEMENT)
                        [tempMatrix, tempLabels] = aggregateFeatureRanks(rankMatrix, featureLabels, 'type', 'placement', 'selection', iPlacement);
                        % TODO: the mapping from feature number to feature name is
                        % correct (i.e. the correct feature label is shown in the plot)
                        % but the feature number is not (i.e. feature #10 in tempMatrix
                        % does not correspond to feature #10 in rankMatrix)
                        handle = plotFeatureRanking(tempMatrix, 'featureNames', tempLabels, ...
                            'plotTitle', [plotTitle ' / Placement ' SETTINGS.SENSOR_PLACEMENT{iPlacement}], 'nTopFeatures', 15);

                        saveas(handle, [savename '_placement_' regexprep(SETTINGS.SENSOR_PLACEMENT{iPlacement}, '[^\w'']', '_') '.pdf']);
                        close(handle);
                    end

                    % different types of sensors (acc/gyr)
                    sensors = getSensorType(SETTINGS.SENSORS_AVAILABLE);
                    for iSensor = 1:length(sensors)
                        [tempMatrix, tempLabels] = aggregateFeatureRanks(rankMatrix, featureLabels, 'type', 'sensor', 'selection', iSensor);
                        % TODO: the mapping from feature number to feature name is
                        % correct (i.e. the correct feature label is shown in the plot)
                        % but the feature number is not (i.e. feature #10 in tempMatrix
                        % does not correspond to feature #10 in rankMatrix)
                        handle = plotFeatureRanking(tempMatrix, 'featureNames', tempLabels, ...
                            'plotTitle', [plotTitle ' / Sensor ' sensors{iSensor}], 'nTopFeatures', 15);

                        saveas(handle, [savename '_sensor_' sensors{iSensor} '.pdf']);
                        close(handle);
                    end
                end
            end
            
            for iTopFeatures = 1:length(featureSetSizes)
                placementMatrix{iSubject}{iTopFeatures} = placementMatrix{iSubject}{iTopFeatures}/featureSetSizes(iTopFeatures);
%                sensorMatrix{iSubject}{iTopFeatures} = sensorMatrix{iSubject}{iTopFeatures}/featureSetSizes(iTopFeatures);
            end
        end
        
        % analysis        
        for iClass = 1:11
            plotMatrix = [];
            for iTopFeatures = 1:length(featureSetSizes)
                plotMatrix(:, iTopFeatures) = placementMatrix{1}{iTopFeatures}(:,iClass);
            end
        
            handle = figure;
            bar(plotMatrix', 'stack');
            title(['Subject 1 / Class ' classLabels{iClass+1} ' / ' evalAbbrToFull(iEvaluation{:})]);
            xlabel('Number of top features');
            ylabel('Feature distribution [%]');
            legend(SETTINGS.SENSOR_PLACEMENT);
            ylim([0 1]);
            set(gca, 'XTickLabel', featureSetSizes);
            set(gca, 'YTickLabel', 0:10:100);
            set(gca, 'YTick', 0:.1:1);
            set(gca, 'TickDir', 'out');
            grid on
            
            savename = [SETTINGS.PATH_OUTPUT '/topFeatureDistribution_' regexprep(classLabels{iClass+1}, '[^\w'']', '_') '_subject1_' evalAbbrToFull(iEvaluation{:}) '.pdf'];
            saveas(handle, savename);
            close(handle);
        end
        
        if 0
            a = cell2num(placementMatrix{1});
            a1 = reshape(a,3,12,[]); % a(placement,class,nFeatures)        
            %{ 
                close all; bar(squeeze(a1(:,1,:))','Stacked')
            %}
            b = cell2num(placementMatrix{1});
            b1 = reshape(a,3,12,[]);
        end
    end
end
