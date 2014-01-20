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

function [confusion metrics scoreEval] = evaluation(prediction, scoresTimeseries, labelsTimeseries, cvTestSegments, cvTestLabelsList, scores, varargin)

[SETTINGS] = process_options(varargin, 'settings', []);

if SETTINGS.VERBOSE_LEVEL >= 2
    fprintf('\n\nEvaluation\n')
end
% (5.1) Evaluating prediction (class assignment)
% (5.1.1) confusion matrix
confusion = confusionmat(labelsTimeseries, prediction);

% (5.1.2) Timeframe-based performance evaluation
m = mset(seq2seg(prediction), seq2seg(labelsTimeseries), 'NULL_ONE', 'nCLASSES', SETTINGS.CLASSES);
if SETTINGS.PLOT
    plot_mset_errors(SETTINGS.CLASSIFIER, 2, 'fullpie', SETTINGS.DATASET, m.t);
end
metrics = mset_metrics(m);
if SETTINGS.VERBOSE_LEVEL >= 1
    fprintf('\nPrecision: %2.2f%%, Recall: %2.2f%%, FPR: %2.2f%%\n', metrics.t.precision*100, metrics.t.recall*100, metrics.t.fpr*100)
end

% (5.2) Score-based performance evaluation
scoreEval.precisionsF = cell(SETTINGS.CLASSES, 1); scoreEval.precisionsD = cell(SETTINGS.CLASSES, 1);
scoreEval.recallsF = cell(SETTINGS.CLASSES, 1); scoreEval.recallsD = cell(SETTINGS.CLASSES, 1);
scoreEval.falloutsF = cell(SETTINGS.CLASSES ,1); scoreEval.falloutsD = cell(SETTINGS.CLASSES, 1);
scoreEval.accuracysF = cell(SETTINGS.CLASSES, 1); scoreEval.accuracysD = cell(SETTINGS.CLASSES, 1);

for c = 1:SETTINGS.CLASSES
    % (1) Evaluation on Timeseries
    assert(~iscell(scoresTimeseries), 'cell structured scores not supported yet');        

    [scoreEval.precisionsF{c} scoreEval.recallsF{c} scoreEval.falloutsF{c} scoreEval.accuracysF{c}] = evaluate(labelsTimeseries, scoresTimeseries, c); 
    
    % (2) evaluate in event space (most effective, as sparse representation, requires criterion) 
    % nonMaximumSupression() % filter scores segments using minimum and
    % [scoreEval.precisionsD{c} scoreEval.recallsD{c} scoreEval.falloutsD{c} scoreEval.accuracysD{c}] = evaluateDetection(cvTestLabelsList, cvTestSegments, scores, c);
end

if SETTINGS.PLOT
    % Visualization
    fRPC = figure();
    fROC = figure();
    CLASSES = SETTINGS.CLASSES
    for c = 1:CLASSES
        figure(fROC);
        subplot(ceil(CLASSES/4), 4, c);
        pr_plot({1-scoreEval.falloutsF{c}, 1-scoreEval.falloutsD{c}}, {scoreEval.recallsF{c}, scoreEval.recallsD{c}}, {'Segmentation', 'Event'}, {[], []}, {'-', '-.'}, 2, 'ROC')
        title(sprintf('\\fontsize{16} \\it %s', SETTINGS.CLASSLABELS{c}));

        figure(fRPC);
        subplot(ceil(CLASSES/4), 4, c);
        pr_plot({scoreEval.precisionsF{c}, scoreEval.precisionsD{c}}, {scoreEval.recallsF{c}, scoreEval.recallsD{c}}, {'Segmentation', 'Event'}, {[], []}, {'-', '-.'}, 2, 'RPC')
        title(sprintf('\\fontsize{16} \\it %s', SETTINGS.CLASSLABELS{c}));
     end

    figure; 
    plotmatAll(confusion, SETTINGS.CLASSLABELS, 'Confusion Gestures', [0 0 0], [0.5 0.5 0.5], 12)
end  
