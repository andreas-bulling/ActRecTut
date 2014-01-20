% run all settings and calculate from scratch
%
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

clear
settings % get output path
% run_results
% iterate through experiments, plot, and output relevant result
P_EX = [SETTINGS.PATH_OUTPUT '/experiments/'];
p_experiments = dir(P_EX)';

for exp = p_experiments
    e = [P_EX exp.name];
    if ~isdir(e) ||strcmp(exp.name(1),'.') ==1%strcmp(exp.name,'.') ==1 || strcmp(exp.name,'..')==1
        continue;
    end
    params = dir(e)';
    for param = params
        p = [e '/' param.name];
        if isdir(p)
           continue;
        end
        s = strrep(param.name,'.','_'); % make safe
        result.(['value_' s]) = [];
        file = load(p,'-mat'); % saver to wrap with file(struct)
        result.(['value_' s]).confusion = file.confusion;
        result.(['value_' s]).metrics = file.metrics;
        result.(['value_' s]).scoreEval = file.scoreEval;
    end
    figure;title(exp.name,'Interpreter', 'none');
    plotEvaluationResults(result, file.SETTINGS, 'ROC');
    clear result;
end


