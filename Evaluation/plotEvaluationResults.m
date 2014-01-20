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

function grouped =plotEvaluationResults(evaluationResult, SETTINGS, type, varargin)
[barcolors, type] = process_options(varargin, 'barcolors', [0.7 0.7 0.7;0.9 0.9 0.9], 'type', 'bars');

fields = fieldnames(evaluationResult);
cleanfields = prettyEvalLabels(fields);
       
for iSweepStep = 1:length(fields)
    stepResult = evaluationResult.(fields{iSweepStep});    
    nSubjects=length(stepResult); % e.g., if multiple subjects
    tmpFallouts =0;
    tmpPrecisions = 0;
    tmpRecalls = 0;
    tmpConfusions = zeros(SETTINGS.CLASSES);
    for iSubject=1:nSubjects
       tmpFallouts = tmpFallouts + stepResult(iSubject).metrics.t.fpr;
       tmpPrecisions = tmpPrecisions + stepResult(iSubject).metrics.t.precision;
       tmpRecalls =tmpRecalls +stepResult(iSubject).metrics.t.recall;
       tmpConfusions = tmpConfusions + stepResult(iSubject).confusion;
    end
    
    % unrolling struct to cell, mean multiple subjects
    fallouts{iSweepStep} = tmpFallouts/nSubjects;
    precisions{iSweepStep} =tmpPrecisions/nSubjects; 
    recalls{iSweepStep} = tmpRecalls/nSubjects; 
    confusions{iSweepStep} = tmpConfusions/nSubjects;
        
        if SETTINGS.VERBOSE_LEVEL >= 1
            %plot_mset_errors(SETTINGS.CLASSIFIER, 2, 'fullpie', SETTINGS.DATASET, stepResult.metrics.t.mset);
            fprintf('\nPrecision: %2.2f%%, Recall: %2.2f%%, FPR: %2.2f%%\n', precisions{iSweepStep}*100, recalls{iSweepStep}*100)
        end
    
end


switch type
    case 'roc'
        colors = cell(length(fields), 1);
        linestyles = cell(length(fields), 1);
        subplot(2,1,1); hold all;
        plot(1-cell2num(precisions), cell2num(recalls));
    case {'bars','plot'}
        if strcmp(type,'bars')==1
            grouped = [cell2num(precisions); cell2num(recalls)]';
            hBars = bar(grouped,'grouped');ylim([0 1]);
            for i=1:length(hBars)
                set(hBars(i),'FaceColor', barcolors(i,:));
            end    
            
            for i=1:size(grouped,1) % create annotations
              % store the handles for later use
                if (grouped(i,1)*100 < 10)
                    prectxt(i) = text(i-0.26,grouped(i,1),sprintf('%3.1f',100*grouped(i,1))) ;
                else
                    prectxt(i) = text(i-0.26,grouped(i,1),sprintf('%3.1f',100*grouped(i,1))) ;
                end
                if (grouped(i,2)*100 < 10)
                    rectxt(i) = text(i+0.26,grouped(i,2),sprintf('%3.1f',100*grouped(i,2))) ;
                else
                    rectxt(i) = text(i+0.26,grouped(i,2),sprintf('%3.1f',100*grouped(i,2))) ;
                end
            end
            % center all annotations at once using the handles
            set([prectxt rectxt],'horizontalalignment','center', ...
              'verticalalignment','bottom','Fontsize',14,'Fontweight','bold') ;             
        else
            plot(cell2num(precisions)); hold all; plot(cell2num(recalls));            
        end        
        set(gca,'XTick',1:length(cleanfields));
        set(gca,'XTickLabel',cleanfields);
        legend({'Precision', 'Recall', 'Precision', 'Recall', 'Precision', 'Recall'},...
            'Fontweight','bold', 'Fontsize',12);
        xticklabel_rotate([],30,[],'Fontsize',14,'Fontweight','bold');             
        
end



% legend({'All data', 'All data', 'Precision', 'Recall'})
%{
for i = 1:length(fields)
   
    tmp = evaluationResult.(fields{i});
    tmpConf = zeros(SETTINGS.CLASSES);
    for p=1:length(tmp)  % number user folds
        tmpConf = tmp(p).metrics.t.mset.Conf';        
    end
    tmpConf = tmpConf/length(tmp);
    figure;
    plotmatAll(tmpConf,SETTINGS.CLASSLABELS, fields{i})
end
%}
% fROC = figure;
% fRPC = figure;
% for e = 1:length(fields)
%   for c = 1:CLASSES
%         figure(fROC);
%         subplot(ceil(CLASSES/4), 4, c);
%         pr_plot({1-scoreEval.falloutsF{c}, 1-scoreEval.falloutsD{c}}, {scoreEval.recallsF{c}, scoreEval.recallsD{c}}, {'Segmentation', 'Event'}, {[], []}, {'-', '-.'}, 2, 'ROC')
%         title(sprintf('\\fontsize{16} \\it %s', labelnames{c}));
% 
%         figure(fRPC);
%         subplot(ceil(CLASSES/4), 4, c);
%         pr_plot({scoreEval.precisionsF{c}, scoreEval.precisionsD{c}}, {scoreEval.recallsF{c}, scoreEval.recallsD{c}}, {'Segmentation', 'Event'}, {[], []}, {'-', '-.'}, 2, 'RPC')
%         title(sprintf('\\fontsize{16} \\it %s', labelnames{c}));
%      end
% end


