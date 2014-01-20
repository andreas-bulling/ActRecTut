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

function [result dataStruct] = selectSensorData(data, varargin)
 
defaultSensorsAvailable = {'acc_1_x', 'acc_1_y', 'acc_1_z', ...
                           'gyr_1_x', 'gyr_1_y', 'gyr_1_z', ...
                           'mag_1_x', 'mag_1_y', 'mag_1_z', ...
                           'acc_2_x', 'acc_2_y', 'acc_2_z', ...
                           'gyr_2_x', 'gyr_2_y', 'gyr_2_z', ...
                           'mag_2_x', 'mag_2_y', 'mag_2_z', ...
                           'acc_3_x', 'acc_3_y', 'acc_3_z', ...
                           'gyr_3_x', 'gyr_3_y', 'gyr_3_z', ...
                           'mag_3_x', 'mag_3_y', 'mag_3_z'};

[FUSION_TYPE sensorsAvailable sensorsUsed verbose] = process_options(varargin, 'fusion', 'early', ...
    'sensorsAvailable', defaultSensorsAvailable, 'sensorsUsed', {'acc', 'gyr', 'mag'}, 'verbose', 0);

if size(data, 2) ~= size(sensorsAvailable, 2)
    error('selectSensorData:dimensionsDontMatch', 'The dimensions of the data matrix and the sensor type vector do not match.');
end

dataStruct = [];
result = [];

for iType = 1:size(sensorsAvailable, 2)
    sensorType = sensorsAvailable{iType};  
    parts = regexp(sensorType, '_', 'split');
    if (length(parts)==1)
        dataStruct.(parts{1}) = data(:, iType);
    else
        dataStruct.(parts{1}){str2num(parts{2})}.(num2str(parts{3})) = data(:, iType);
    end
end

if verbose >= 2
    fprintf('  -> Using sensors %s\n', print_cell(sensorsUsed, 0));
end

for iSensor = sensorsUsed
    parts = regexp(iSensor{:}, '_', 'split');
    nParts = size(parts, 2);
    
    switch nParts
        case 1
            selectedData = [];
            for i = 1:size(dataStruct.(parts{1}), 2)
                selectedData = [selectedData cell2mat(struct2cell(dataStruct.(parts{1}){i})')];
            end
            
        case 2
            selectedData = cell2mat(struct2cell(dataStruct.(parts{1}){str2num(parts{2})})'); % flatten structure
            
        case 3
            selectedData = dataStruct.(parts{1}){str2num(parts{2})}.(parts{3});
    end
    
    switch FUSION_TYPE
        case 'early'
            result = [result selectedData];
            
        case 'late'
            result{length(result)+1, 1} = selectedData;
    end
end