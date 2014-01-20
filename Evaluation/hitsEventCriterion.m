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

function hits = hitsEventCriterion(labels, segments)
    % Criterion: Midpoint of segments falls into label
    nLabels = size(labels,1);
    nSegments = size(segments,1);
    hits(1:nLabels) = 0;
    for l = 1:nLabels
        for s=1:nSegments
            startS = segments(s,1);
            stopS = segments(s,2);

            startL = labels(l,1);
            stopL = labels(l,2);        
            mid=(startS+stopS)/2;

            if (mid>startL) && (mid<stopL)
                hits(l) = hits(l) +1;
            end
        end
    end