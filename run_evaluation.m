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

function [confusion, metrics, scoreEval varargout] = run_evaluation(features, fType, fDescr, segments, segmentation, labelsSegmentation, featureLabels, SETTINGS)

% Prepare additional variables
if iscell(features{end}) % unfortunate hack
    cvScores = cell(length(features{end}), 1);
else
    cvScores = zeros(length(cell2mat(labelsSegmentation)), SETTINGS.CLASSES);
end
cvFeatSelection = cell(0);
offset = 0;
%fSelectionTime = zeros(1, SETTINGS.FOLDS);
%trainingTime = zeros(1, SETTINGS.FOLDS);
%testTime = zeros(1, SETTINGS.FOLDS);
%cvTestLabels = zeros(length(cell2mat(labelsSegmentation)), 1);
%cvTestSegments = zeros(length(cell2mat(labelsSegmentation)), 2);
%cvTestLabelsList = zeros(length(cell2mat(segments)), 6);
startIndex = 1;
startIndexSegments = 1;

if iscell(SETTINGS.FOLDS)
    subfolds = SETTINGS.FOLDS;
    SETTINGS.FOLDS = length(subfolds);
else
    subfolds = 1:SETTINGS.FOLDS;
end

%%

% (4) Training and Classification
for iFold = 1:SETTINGS.FOLDS
    if SETTINGS.VERBOSE_LEVEL >= 2
        fprintf('\nFOLD %i/%i\n', iFold, SETTINGS.FOLDS)
    else
        fprintf('.')
    end
    testSet = iFold;
    trainingSet = setdiff(1:SETTINGS.FOLDS, iFold);
    % trainigdata reduction: simplified case.
    removeT = 1:SETTINGS.REDUCTION_TRAINDATA;
    idx = 1:length(trainingSet);
    trainingSet = trainingSet(setdiff(idx,removeT));
    
    % for person-independent evaluation
    if iscell(subfolds)
        testSet = subfolds{testSet};
        trainingSet = subfolds{trainingSet};
        % simple Adaption (better: self-learning, semi-supervised)
        % here take n sequentially out (better eval: random subsampling)
        adaptiveSamples = testSet(1:SETTINGS.ADAPTIVE_SAMPLES);
        testSet = setdiff(testSet,adaptiveSamples); % remove
        trainingSet = union(trainingSet, adaptiveSamples); % insert
    end
    % (4.1) Create training and test data sets
    trainingData = prepareEvaluationData(features(trainingSet));
    testData = prepareEvaluationData(features(testSet));
   
    trainingLabels = cell2mat(labelsSegmentation(trainingSet));
    testLabels = cell2mat(labelsSegmentation(testSet));

    % (4.2) Standardize training and test data sets
    [trainingData testData] = standardizeData(trainingData, testData, 'verbose', SETTINGS.VERBOSE_LEVEL);

    % (4.3) Feature selection
    [selectedFeatures fSelectionTime(iFold)] = feature_selection(trainingData, trainingLabels, 'method', SETTINGS.FEATURE_SELECTION, ...
        'options', SETTINGS.FEATURE_SELECTION_OPTIONS, 'verbose', SETTINGS.VERBOSE_LEVEL);
    cvFeatSelection{length(cvFeatSelection)+1} = selectedFeatures;
    if SETTINGS.VERBOSE_LEVEL > 2
        fprintf('Selected features: %s\n', print_cell(featureLabels(selectedFeatures)));
    end
    
    % compare sensor 1 and sensor 2, 12 groups/classes
    if 0
        x = [testData{1}(:,[1 2]) testData{2}(:,[1 2])];
        gplotmatrix(x, [], testLabels, [], '+xo', [], 'on', '', [fDescr fDescr])
        [d,p,stats] = manova1(x, testLabels);
        c1 = stats.canon(:,1);
        c2 = stats.canon(:,2);
        gscatter(c2, c1, testLabels, [], 'oxs')
        gname
        grpstats(x, testLabels)
        stats.gmdist
    end
    
    if SETTINGS.SAVE
        % save text output
        dlmwrite('test_data.txt', testData, ' ');
        dlmwrite('test_labels.txt', testLabels-1, ' ');
        dlmwrite('train_data.txt', trainingData, ' ');
        dlmwrite('train_labels.txt', trainingLabels-1, ' ');
    end

    % (4.4) Train classifier
    [model trainingTime(iFold)] = training(trainingData, trainingLabels, 'method', SETTINGS.CLASSIFIER, ...
        'selectedfeatures', selectedFeatures, 'options', SETTINGS.CLASSIFIER_OPTIONS, 'classlabels', SETTINGS.CLASSLABELS, 'verbose', SETTINGS.VERBOSE_LEVEL);

    % (4.5) Classify
    [scores testTime(iFold)] = classification( ...
        model, testData, 'method', SETTINGS.CLASSIFIER, 'selectedfeatures', selectedFeatures, 'options', SETTINGS.CLASSIFIER_OPTIONS, ...
        'verbose', SETTINGS.VERBOSE_LEVEL);

    % (4.6) Concatenate fold
    if SETTINGS.VERBOSE_LEVEL >= 2
        disp('  -> Concatenating fold');
    end
    %cvTestLabels = [cvTestLabels; testLabels];
    cvTestLabels(startIndex:startIndex + size(testLabels, 1) - 1) = testLabels; % label by Segment
    if iscell(scores)
        for l = 1:length(scores)
            cvScores{l} = [cvScores{l}; scores{l}];
        end
    else
        %cvScores = [cvScores; scores];
        cvScores(startIndex:startIndex + size(scores, 1) - 1, :) = scores; % score by segment
    end
% <<<<<<< .mine
%    % debug single testset to multiple: (segmentation{testSet}) to cell2mat(segmentation(testSet))
%    cvTestSegments = [cvTestSegments; cell2mat(segmentation(testSet)) + offset]; % segments in timeframes
%    tmp = cell2mat(segments(testSet));
%=======
    %cvTestSegments = [cvTestSegments; segmentation{testSet} + offset];
    cvTestSegments(startIndex:startIndex + size(cell2mat(segmentation(testSet)), 1) - 1, :) = cell2mat(segmentation(testSet)) + offset;  % segments in timeframes
    startIndex = startIndex + size(cell2mat(segmentation(testSet)), 1);
    tmp = cell2mat(segmentation(testSet));
%>>>>>>> .r280
    tmp(:, 1:2) = tmp(:, 1:2) + offset;
    %cvTestLabelsList = [cvTestLabelsList; tmp];
    cvTestLabelsList(startIndexSegments:startIndexSegments + size(tmp, 1) -1, :) = tmp; % labels in timeframes
    startIndexSegments = startIndexSegments + size(tmp, 1);
    offset = max(cvTestSegments(:, 2));
    
    % (4.7) Fusion of multiple classifier scores
    [scores confidence] = fusion(cvScores, 'verbose', SETTINGS.VERBOSE_LEVEL);
    
     %{
    % FOR understanding whats happening:
    [p c] = max(cvScores, [],2); % argmax[c] (scores) for each sample i    
     figure;
     subplot(3,1,1); plot(cvTestLabels); hold all; plot(c); legend('groundtruth','classification');
     subplot(3,1,2); plot(cvScores); title('scores');legend(labelnames);
    
    figure; 
 
    plot(testLabels,'Color',[0 0 0],'LineStyle','--','Marker', 'o', 'MarkerEdgeColor',[0 1 0]);
    hold all
    plot(decision(scores,'Color',[0 0 1],'LineStyle','none','Marker', '.');
    
    
    figure; 
    tmpscoresTimeseries = segmentsToTimeseries(segmentation{testSet}, decision(scores), -inf);
    tmplabelsTimeseries = segmentsToTimeseries(segmentation{testSet}, testLabels, -inf); 
    plot(tmplabelsTimeseries,'Color',[0 0 0],'LineStyle','--','Marker', 'o', 'MarkerEdgeColor',[0 1 0]);
    hold all
    plot(tmpscoresTimeseries,'Color',[0 0 1],'LineStyle','none','Marker', '.');
    %}
    %{
    % hereyou can see the scores per class for all CLASSES
    figure;
    for class=1:12    
        col = illustrateLabelsEfficient(cvTestLabelsList(:,[1 2 4]),class,1.2);
        tmpScore= line([cvTestSegments(:,1) cvTestSegments(:,2)]',[cvScores(:,class) cvScores(:,class)]',...
            'color',col,'LineWidth',2);    
    end
    %}
    %{
    % hereyou can see the scores per class separately, helps to check
    firing segments
    figure;
    for class=1:12    
        illustrateLabelsEfficient(cvTestLabelsList(:,[1 2 4]),class,-1,0, 1);
        tmpScore= line([cvTestSegments(:,1) cvTestSegments(:,2)]',[cvScores(:,class) cvScores(:,class)]',...
        'color',[0 0 0],'LineWidth',2);
        pause(1);
        delete(tmpScore); xlim([0 max(cvTestSegments(:,2))]);
    end
    %}
end

varargout(1) = {cvFeatSelection};

if SETTINGS.VERBOSE_LEVEL >= 1
    fprintf('\nAverage Time for Feature Selection: %2.4f seconds\nAverage Time for Training: %2.4f seconds\nAverage Time for Testing: %2.4f seconds', ...
        mean(fSelectionTime), mean(trainingTime), mean(testTime))
end

% (4.8) Timeframe-based scores
scoresTimeseries = segmentsToTimeseries(cvTestSegments, scores, -inf);
% debug: sum(labelsAll-labelsTimeseries)==0, otherwise something is wrong.
labelsTimeseries = segmentsToTimeseries(cvTestSegments, cvTestLabels', -inf); 
% hack due to segmentation change for adaption, TODO: make alle segments
% relative start,end, insert mergeSegments, line 60
if (SETTINGS.ADAPTIVE_SAMPLES>0)
    scoresTimeseries = scoresTimeseries(labelsTimeseries~=-inf,:);
    labelsTimeseries = labelsTimeseries(labelsTimeseries~=-inf,:);
end
% (4.9) Convert scores into prediction
prediction = decision(scoresTimeseries);

% (5) Evaluation
[confusion metrics scoreEval] = evaluation(prediction, scoresTimeseries, labelsTimeseries, cvTestSegments, cvTestLabelsList, scores, 'settings', SETTINGS);
