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

function prettyPrintStats( stats, labelnames )

    for l=1:length(labelnames)
        fprintf('%d. Class: \"%s\"\n Occurences: %d | Mean Duration: %2.2fs (%2.2fs)\n Total duration %2.2fs (%2.2f%%)\n',...
            l,labelnames{l},stats(l,1),stats(l,2)/32,stats(l,3)/32, stats(l,4)/32, 100*stats(l,4)/sum(stats(:,4)));
    end
    
end

