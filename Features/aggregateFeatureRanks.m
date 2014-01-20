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

function [rankMatrix, featureLabels] = aggregateFeatureRanks(rankMatrix, featureLabels, varargin)
    [type selection] = process_options(varargin, 'type', 'placement', 'selection', 1);
    
    indices = selectFeatures(featureLabels, 'type', type)==selection;
    rankMatrix = rankMatrix(indices, :);
    featureLabels = featureLabels(indices);
end

function result = selectFeatures(labels, varargin)
    [type] = process_options(varargin, 'type', 'placement');
    nLabels = size(labels, 2);
    result = zeros(nLabels, 1);
    
    switch type
        case 'placement' % aggregate acc and gyr (all axes) for each placement
            for i = 1:nLabels
                parts = regexp(labels{i}, '_', 'split');
                result(i) = str2num(parts{3});
            end
            
        case 'sensor'  % aggregates all placements and axes for each sensor type
            for i = 1:nLabels
                parts = regexp(labels{i}, '_', 'split');
                sensorType = parts{2};
                if strcmp(sensorType, 'acc')
                   result(i) = 1;
                else
                   result(i) = 2; 
                end
            end
    end
end