% Confusion matrix plotting
%
% Plots a confusion matrix as a 2D figure with values encoded as colors
%
% handle = plotConfusionMatrix(matrix, varargin)
%
% Parameters:
%     matrix      confusion matrix as returned by classification and mset scripts
%                 (ground truth on the horizontal axis and prediction on the vertical)
%     classes     cell array of class labels (strings)
%     varargin    variable argument list: colormap, plotcolorbar, fontname,
%                                         fontsize, normalise, plotvalues,
%                                         debug, decimalplaces,
%                                         plotallvalues
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

function handle = plotConfusionMatrix(matrix, classes, varargin)

[ cmap, plotcolorbar, fontname, fontsize, normalise, plotvalues, debug, decimalplaces, plotallvalues ] = process_options( varargin, ...
    'cmap', 'hot', 'plotcolorbar', 1, 'fontname', 'Arial', 'fontsize', 10, 'normalise', 1, 'plotvalues', 1, 'debug', 0, 'decimalplaces', 2, 'plotallvalues', 0 );

if( ~exist('matrix', 'var') )
    error('plotConfusionMatrix:BadParameter', 'Please provide a confusion matrix.');
end

if( ~exist('classes', 'var') )
    error('plotConfusionMatrix:BadParameter', 'Please provide the classlabels.');
end
    
[nRows nColumns] = size(matrix);

if( nRows ~= nColumns )
    error('plotConfusionMatrix:BadParameter', 'Confusion matrix needs to be squared.');
end

nClasses = nRows;

if( nClasses ~= length(classes) )
    error('plotConfusionMatrix:BadParameter', 'Labels for all classes need to be provided.');
end

if( debug )
    matrix
end

% settings
handle = figure;

set(gca, 'CLim', [0 1]);
set(gca, 'GridLineStyle', '-');
set(gca, 'XGrid', 'off');
set(gca, 'YGrid', 'off');
set(gca, 'Layer', 'top');
set(gca, 'Box', 'on');
set(gca, 'ytick', 1:nClasses);
set(gca, 'xtick', 1:nClasses);
set(gca, 'xticklabel', [])
set(gca, 'yticklabel', [])
set(gca, 'ticklength', [0 0]);
set(gca, 'FontName', fontname);
set(gca, 'FontSize', fontsize);
%set(gca, 'square');

xlabel('Predicted class');
ylabel('Actual class');

set(gcf, 'Color', 'w');

if( normalise )
    % normalise across ground truth columns
    matrix = bsxfun(@rdivide, matrix, sum(matrix));
    matrix(isnan(matrix)) = 0;
    title('Normalised confusion matrix');
else
    title('Confusion matrix');
end

% plot
cmap = flipud(eval(cmap));
colormap(cmap);
rectangle('Position', [1 1 nClasses-1 nClasses-1], 'facecolor', 'w', 'edgecolor', 'w');

maxTextLength = 0;
for classString = classes'
    if( length(classString) > maxTextLength )
        maxTextLength = length(classString);
    end
end

for idy = 1:nRows
    for idx = 1:nColumns
        color = round(matrix(idx, idy) * 64);
        if( color == 0)
            color = 1;
        end
        
        rectangle('Position', [idx-1 nClasses-idy 1 1], 'facecolor', cmap(color,:), 'edgecolor', cmap(color,:));
        
        if( idy == 1 ) % print x-axes label
            t = text(idx-0.9, -0.8, classes{idx});
            set(t, 'FontName', fontname);
            set(t, 'FontSize', fontsize);
        end
        
        if( mod(idx, nClasses) == 0 ) % print y-axes label
            t = text(-maxTextLength*0.1, idy-0.6, classes{nClasses-idy+1});
            set(t, 'FontName', fontname);
            set(t, 'FontSize', fontsize);
        end

        if( plotvalues )
            modifier = 10^decimalplaces;
            value = round(matrix(idx, idy)*modifier)/modifier;
            if( plotallvalues || value > 0.00 )
                t = text(idx-0.65, nClasses-idy+0.5, sprintf(['%0.' num2str(decimalplaces) 'f'], value));
                set(t, 'FontName', fontname);
                set(t, 'FontSize', fontsize);
            end
        end
    end
end

if( plotcolorbar )
    colorbar('YTickLabel', 0:0.1:1, 'YLim', [0 1]);
end
