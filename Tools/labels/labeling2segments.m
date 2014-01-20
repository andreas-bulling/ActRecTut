% function seglist = labeling2segments(labeling, labelbase)
% 
% Converts a consecutive labeling stream into a list of segments. 
% Each line of SEGMENTS contains one segment, where the first element
% contains the start sample number, the 2nd the stop sample number, 3rd the
% number of samples, 4th the labeling number.
% 
% labelbase - threshold above segments are created 
%   shift labeling basis: 0=default, 1=report zero-label segments
%
% Returns a segment list with the following columns:
% [START STOP LENGTH LABEL COUNT CONFIDENCE]  (LENGTH is in samples)
% 
% See also segments2labeling.
%
% Copyright 2005 Georg Ogris, UMIT CSN Innsbruck
% Copyright 2005, 2006 Oliver Amft, ETH Zurich, Wearable Computing Lab.
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

function seglist = labeling2segments(labeling, labelbase)

if (exist('labelbase','var')~=1), labelbase = 0; end;

if (~isvector(labeling)), error('labeling must be a vector'); end
labeling = labeling(:);
labeling = labeling+labelbase; % added, oam

seglist = [];
labels = [];

for i = 1:max(labeling)
    if ~all( labeling~=i )
        labels = [labels i];
    end
end

for seg = labels
    ilab = labeling.*(labeling==seg) ;
    interim = circshift(ilab,[1 0]) ;
    interim(1,:) = 0 ;
    startstop = ilab - interim ;

    seg_starts = find( startstop ==  seg ) ;
    seg_stops  = find( startstop == -seg ) - 1 ;
    if length(seg_stops) - length(seg_starts)
        seg_stops(end+1,1) = length(ilab) ; 
    end
    seg_lengths = (seg_stops - seg_starts) + 1 ;

    tmp_seglist = [];
    if ~isempty(seg_starts)
        tmp_seglist(1:size(seg_starts,1), 1) = seg_starts;
        tmp_seglist(1:size(seg_starts,1), 2) = seg_stops;
        tmp_seglist(1:size(seg_starts,1), 3) = seg_lengths;
        tmp_seglist(1:size(seg_starts,1), 4) = zeros(size(seg_starts))+seg-labelbase;
        
        seglist = [seglist; tmp_seglist];
%         tmp_seglist(end+1:end+size(seg_starts,1),1:4) = ...
%             [seg_starts,seg_stops, ...
%              seg_lengths,zeros(size(seg_starts))+seg];
    end
end

[tmp,idx] = sort(seglist,1);
if (~isempty(idx))
    seglist = seglist(idx(:,1),:);
%     seglist(:,4) = seglist(:,4)-labelbase; % added, oam
    seglist(:,5) = (1:size(seglist,1)).';
    seglist(:,6) = 1; %ones(size(seglist,1),1);
end;

