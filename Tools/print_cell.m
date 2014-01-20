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

function result = print_cell(cellarray, print_int)

result = '';

if isstruct(cellarray)
    for field = fieldnames(cellarray)'   
        result = sprintf('%s %s', result, field{:});
        
        for element = 1:length(cellarray.(field{:}))
            if element == 1
                result = sprintf('%s[%i', result, num2str(cellarray.(field{:})(element)));
            else
                result = sprintf('%s, %i', result, num2str(cellarray.(field{:})(element)));
            end
        end
        
        result = sprintf('%s]', result);
    end
else
    for element = 1:length(cellarray)
        if element == 1
            if print_int
                result = sprintf('%s (%i)', num2str(cellarray{element}), element);
            else
                result = sprintf('%s', num2str(cellarray{element}));
            end
        else
            if print_int
                result = sprintf('%s, %s (%i)', result, num2str(cellarray{element}), element);
            else
                result = sprintf('%s, %s', result, num2str(cellarray{element}));
            end
        end
    end    
end