% Simple Non-Maximum-Supression:
% (Other: e.g., mean shift)
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

function scores = fuseSegments(segments, scores, class, overlapThreshold)

scores = [segments scores];
[v i] = sort(scores(:, class + 3),'descend'); % sort to remove overlapping lower ones
scores = scores(i,:);

keep(1:size(scores,1)) = 1;
for i=1:size(scores,1)
    if keep(i)
        for j=i+1:size(scores,1)
            if keep(j)
                start1 =scores(i,1);
                stop1 =scores(i,2);
                start2=scores(j,1);
                stop2 =scores(j,2);
                
                startIntersect=max(start1,start2);
                stopIntersect=min(stop1,stop2);
                startUnion=min(start1,start2);
                stopUnion=max(stop1,stop2);
                if inside(start1,stop1,start2,stop2)
                    keep(j)=0;
                end
                if (overlaps(start1,stop1,start2,stop2) && (stopIntersect-startIntersect+1)/(stopUnion-startUnion+1)>overlapThreshold)
                    keep(j)=0;
                end
            end
        end
    end
end
scores = scores(keep==1,:);

function o = overlaps(s1,e1,s2,e2)
if (s1>=s2 && s1<=e2 || e1 >= s2 && e1 <= e2 || s2>=s1 && s2 <=e1 || e2 >=s1 && e2<=e1)
    o=true;
else
    o=false;
end

function o = inside(s1,e1,s2,e2)
if (s2>=s1 && s2 <=e1 || e2 >=s1 && e2<=e1)
    o=true;
else
    o=false;
end