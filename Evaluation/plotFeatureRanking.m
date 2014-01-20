% Feature rank plotting
%
% Plots a figure showing the ranking of features
%
% handle = plotFeatureRanking(matrix, varargin)
%
% Parameters:
%     matrix      rank matrix (features in rows, folds in columns)
%     varargin    variable argument list: featureNames, nTopFeatures, fontSize
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

function handle = plotFeatureRanking(matrix, varargin)
    [ featureNames, nTopFeatures, fontSize, yLimit, featureGroups, featGroupFnct, plotTitle, rotate, DEBUG ] = process_options( varargin, ...
        'featureNames', {}, 'nTopFeatures', 15, 'fontSize', 16, 'yLimit', 'auto', 'featureGroups', 5, ...
        'featGroupFnct', @getFeatureGroup, 'plotTitle', 'NaN', 'rotate', 0, 'debug', 0);

    if( ~exist('matrix', 'var') )
        error('plotFeatureRanking:BadParameter', 'Please provide a rank matrix.');
    end
    
    % Calculate top features and median ranks from rank matrix
    [iTopSelect medval] = calculateTopFeatures(matrix, 'nTopFeatures', nTopFeatures);
    
    % Create colormap
    colors = gray(20);
    colors(colors(:,1)<=0.4, :) = [];
    colors(end,:) = [];
    colors = colors(randInteger(size(colors,1), featureGroups), :);

    % Plot main figure
    handle = figure;
    hold on;
    iPos = 1;
    maxRank = 0;    
    for iF = iTopSelect
        ranks = matrix(iF,:);
        iValid = find(ranks>0);
        usedRanks = ranks(iValid);

        if ~isempty(iValid>0)
            y1 = max(usedRanks);
            y2 = min(usedRanks);
            
            if y1 > maxRank
                maxRank = y1;
            end

            if y1-y2 == 0
                y1 = y1 + .5;
                y2 = y2 - .5;
            end

            % bar
            rectangle('Position', [iPos-.25 y2 .5 y1-y2], 'facecolor', colors(featGroupFnct(iF), :), 'edgecolor', 'k');
            
            % single ranks
            plot( repmat(iPos,length(usedRanks), 1), usedRanks, 'b.', 'markersize', 25, 'LineStyle','none');
            
            % median rank
            plot( iPos, medval(iF), 'k*', 'markersize', 12, 'LineStyle', 'none','Color', [0 0 0], 'LineWidth', 1);
            
            % total usage count at the top of each bar
            text( iPos-0.05, y1+1, num2str(length(iValid)), 'FontSize', fontSize, 'FontWeight', 'bold' );

            for iRank = unique(ranks(ranks>0))
                indices = find(ranks==iRank);
                text( iPos+0.15, iRank, num2str(length(indices)), 'FontSize', fontSize );
            end
        end
        iPos = iPos+1;
    end

    % Generate and output feature labels for x axis
    labels = {};
    legendLabels = '';
    for i = 1:length(iTopSelect)
        legendLabels = sprintf('%s\n%s', legendLabels, ['F' num2str(i) ': ' featureNames{iTopSelect(i)}]);
        labels = {labels{:} ['F' num2str(i)]};

        if DEBUG
            disp([num2str(iTopSelect(i)) ' (' featureNames{iTopSelect(i)} ')']);
            matrix(iTopSelect(i), :);
            disp('');
        end
    end

    % Rotate x axis labels if requested
    if rotate
        xticklabel_rotate(1:length(iTopSelect), 45, labels, 'interpreter', 'none');
    else
        set(gca, 'XTick', 1:length(labels));
        set(gca, 'XTickLabel', labels);
    end
    
    % Make sure the is enough space for the total usage count at the top of
    % each bar
    if ~isnumeric(yLimit)
        yLimit = maxRank + 2;
    end    
    set(gca,'YGrid','on', 'XGrid', 'off', 'YLim', [1 yLimit] );
    
    % Increase font size
    leg = findobj(gcf, 'type', 'text');
    set(leg, 'FontSize', fontSize);
    
    % Plot legend
    legendLabels(1) = [];
    text(1, 20, legendLabels, 'BackgroundColor', [1 1 1], 'edgecolor', 'k', 'interpreter', 'none', 'Margin', 5);

    % Beautification
    title(plotTitle);
    xlabel('Feature', 'FontSize', fontSize);
    ylabel('Rank within feature set', 'FontSize', fontSize, 'Rotation', 90);
    set(gcf, 'color', 'white');
    set(gca, 'TickDir', 'out');
    text(-1, 1, 'Top'); 
end
