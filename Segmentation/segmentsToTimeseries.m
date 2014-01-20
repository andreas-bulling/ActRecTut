%Given a list of segments(n,2) with start and stop frames and corresponding
% values (such as a label or a score), an array is returned
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

function timeseries = segmentsToTimeseries(segments,value, fillup)

if iscell(value)
    timeseries = cell(length(value),1);
    for i=1:length(value)
        timeseries{i} = segmentsToTimeseries(segments,value{i}, fillup);
    end
    return;
end
timeseries(1:max(segments(:,2)),1:size(value,2)) = -inf;
for s=1:size(segments,1)
    start = segments(s,1);
    stop = segments(s,2);
    v = value(s,:);
    assert(stop>=start);
    timeseries(start:stop,:) = max(repmat(v,stop-start+1,1), timeseries(start:stop,:));
end
%assert(sum(sum(timeseries==inf))==0);
timeseries(timeseries==-inf) = fillup;