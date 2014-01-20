% Plots precision/recall curves for
% ps{E}(T),rs{E}(T): Where E corresponds to an experiment and list of
% recall and precision (respectively 1-fallout for ROC) values for T thresholds.
% legend_strs{E}: Name of experiment
% colors{E}(1:3): Color for plot line
% line_styles{E}: style(string) for plot line 
% line_width{E}: width of plot line
% type: 'ROC'or 'RPC': Either ROC curve or RPC curve
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

function pr_plot(ps, rs, legend_strs, colors, line_styles, line_width, type)

ROC = false;
if (strcmp(type,'ROC')==1)
    ROC = true;
end

font_size = 12;
%figure
hold on;

assert(length(ps) == length(rs));
assert(length(ps) == length(legend_strs));
assert(length(ps) == length(colors));

for i = 1 : length(ps)
    if isempty(line_styles{i})
        line_styles{i} = '.';
    end
    if isempty(colors{i})
        colors{i} = rand(3,1);
    end
  %  plot(1 - ps{i}, rs{i}, 'LineWidth', line_width, 'LineStyle', line_styles{i});
    plot(1 - ps{i}, rs{i}, 'Color', colors{i}, 'LineWidth', line_width, 'LineStyle', line_styles{i});
end

grid on;
axis([0 1 0 1]);
% 
if ROC
    xlabel('1 - true negative rate', 'FontSize', font_size);
else
    xlabel('1 - precision', 'FontSize', font_size);   
end
 ylabel('recall', 'FontSize', font_size);

% compute average precision or area under curve
legend_strs_ap = cell(size(legend_strs));
for i = 1 : length(ps)
    if ROC
        roc = areaROC(ps{i}, rs{i});
        %legend_strs_ap{i} = sprintf('%s (AUC = %0.1f)', legend_strs{i}, roc);
        legend_strs_ap{i} = sprintf('%s', legend_strs{i});
    else
        ap = avgprec(ps{i}, rs{i});
        %legend_strs_ap{i} = sprintf('%s (AP = %0.1f)', legend_strs{i}, 100 * ap);
        legend_strs_ap{i} = sprintf('%s', legend_strs{i});
    end
end

legend(legend_strs_ap,'Interpreter', 'none');
set(gca, 'FontSize', font_size);

end


