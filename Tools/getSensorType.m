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

function type = getSensorType(value)

if iscell(value)
    type = {};
    
    for iValue = 1:numel(value)
        parts = regexp(value{iValue}, '_', 'split');
        if ~contains(type, parts{1})
            type = {type{:} parts{1}};
        end
    end
else
    parts = regexp(value, '_', 'split');

    switch parts{1}
        case 'acc'
            type = 1;

        case 'gyr'
            type = 2;
    end
end