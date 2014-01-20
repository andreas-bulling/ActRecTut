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

function labels = generateFeatureLabels(singleLabels, SETTINGS)

sensors_used = SETTINGS.SENSORS_USED;
sensors_avail = SETTINGS.SENSORS_AVAILABLE;
labels = {};

for iSensor = 1:size(sensors_avail, 2)
    for iUsed =1:size(sensors_used, 2)
        for iSingleLabel = 1:size(singleLabels, 2)  
            if (strmatch(sensors_used{iUsed}, sensors_avail{iSensor}))
                 labels{end+1} = [singleLabels{iSingleLabel} '_' sensors_avail{iSensor}];
            end
        end
    end
end

