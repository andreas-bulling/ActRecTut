% function labeling = segments2labeling(segments, totalsize)
%
% is the inverse operation of
% SEGMENTS = LABELING2SEGMENTS(LABELING).
%
% ATTENTION: length(SEGMENTS2LABELING(LABELING2SEGMENTS(LABELING))) most
% likely won't be length(LABELING), because the list of segments does
% not contain information whether there is any nor how long the last
% zero-label is. However this behaviour can be achieved with the optional
% parameter totalsize. The labeling will be extended to this size.
%
% See also LABELING2SEGMENTS.
% 
% Copyright 2005 Georg Ogris, UMIT CSN Innsbruck
% Copyright 2005 Oliver Amft
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

function labeling = segments2labeling(segments, totalsize)

labeling = [];

if ~exist('totalsize','var'), totalsize = segments(end,2); end;
if isempty(totalsize), return; end;

if (size(segments,2) >= 4), labels = segments(:,4); else labels = ones(size(segments,1),1); end;

labeling = zeros( totalsize,1 );
for seg = 1:size(segments,1)
    labeling( segments(seg,1) : segments(seg,2) ) = labels(seg);
end
labeling = labeling(1:totalsize);  % restrict to totalsize
