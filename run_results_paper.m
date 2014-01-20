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

% result selection for paper (provide this script in first deployment)
clear
% (1) Knn (k=1), MeanVar, Hand-only, early fusion.
p_experiments= {
    'expStudy_1_1chain_wrist',...
    'expStudy_1_2chain_alldata',...
    'expStudy_2_1_1features'...
    'expStudy_2_1features'...    
    'expStudy_2_2window',...
    'expStudy_2_2_1window',...
    'expStudy_2_3placements'...
    'expStudy_2_4modality_pd'... 
    'expStudy_2_4modality_pi'...
    'expStudy_3_1classifier',...
    'expStudy_3classifier',...
    'expStudy_4_1_1feature_selection',...% 20 features
    'expStudy_6_2adaption_classifier',...% using SVM
    'expStudy_6_2amount_train_classifier',...% using SVM
    'expStudy_special_feature_selection',...
    'expStudy_4_1_2_feature_selection_sweepset'...
    'expStudy_4_1_3_feature_selection_classes'
    };

selectedEx = [2 1] ;
% run all settings and calculate from scratch
p_experiments = p_experiments(selectedEx);
showImprovement = 1;

barcolor = [0.7 0.7 0.7;0.9 0.9 0.9];
settings % get output path
% run_results
% iterate through experiments, plot, and output relevant result
P_EX = [SETTINGS.PATH_OUTPUT '/experiments/archive/']; %archive/window=0.25s/
if (showImprovement)
     foverall = figure;  hold all;
     barcolor = [0.5 0.5 0.5;0.5 0.5 0.5];
end

 for iexp = 1:length(p_experiments)
    if (~showImprovement)
        foverall = figure;
    end
    %subplot(1,length(p_experiments),iexp);
    e = [P_EX p_experiments{iexp}];
    params = dir(e)';
    xtickNames = cell(0);
    result = struct;
    for param = params
        p = [e '/' param.name];
        if isdir(p) 
           continue;
        end

        s = strrep(param.name,'.','_'); % make safe
        s = strrep(s,'-','_'); % make safe
        s = regexprep(s,'subject\d','');
        file = load(p,'-mat'); % saver to wrap with file(struct)
        
        tmpResult = [];
        tmpResult.confusion = file.confusion;
        tmpResult.metrics = file.metrics;
        tmpResult.scoreEval = file.scoreEval;
        
        if (~isfield(result,['value_' s])) 
            result.(['value_' s]) = [];
            xtickNames{length(xtickNames)+1} = num2str(file.SETTINGS.W_SIZE_SECOND);
        end
        result.(['value_' s]) = [result.(['value_' s]) tmpResult];
    end  
   
    plotEvaluationResults(result, file.SETTINGS, 'ROC','barcolors', barcolor, 'type','bars');    
  
    title(p_experiments{iexp},'Interpreter', 'none');    
    clear result;    
    barcolor = [0.7 0.7 0.7;0.9 0.9 0.9];
 end
 