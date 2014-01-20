% function segments = seq2seg( seq );
%
% * seq : input
%   continuous sequence of labels
%   [label1, label2,.. labeln]
% * segments : output
%   3 column segment encoding of label sequence
%   [start stop label] 
%
% Note: segment timing begins at ZERO
%
% e.g. seq = [0 1 0 0 0 2 2 2 2 2 0]
%  corresponds to:  segments = [1 2 1; 5 10 2]
%
% * 'showZeroLabels', true|(false) : optional input pair
%   if true, explicitly show zero labelled segments. For the above example this would look like: 
%   [0 1 0; 1 2 1; 2 5 0; 5 10 2]
%   (default is false -> only non zero labels are returned as segments)
% * 'resample', smp : optional input pair
%   resample such that the output is 1/smp * input
%   e.g. If the input is sampled at smp, then the output segments will be specified in seconds.
%
% Copyright 2009 Jamie A. Ward, Lancaster University
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

function segments = seq2seg( seq, varargin );
 
sample_rate = 1;
showZeroLabels = false;

if nargin > 0 
    for n=1:2:nargin-1
        switch(varargin{n})
            case 'showZeroLabels'                
                showZeroLabels = varargin{n+1};
            case 'resample'                
                sample_rate = varargin{n+1};
            otherwise
                disp(strcat('unrecognised argument to seg2seq: ',varargin{n}));
        end
    end
else   
   help seg2seq
   error('Not enough input arguments.');
end

START = 1;
STOP = 2;
LABELS = 3;

if isempty(seq)
    segments = [];
    return;
end

    [seqLen, num_labelCols] = size(seq);

    % Find all the segment locations, start and stop times
    lab_changes = find(diff( seq(:,1) ));
    
    seg_start = [0; lab_changes];              %%  add initial section, starting at sample 1, time zero.
    seg_stop = [ lab_changes; seqLen-1 ]; %% add the final section, ending at len(seq)-1
    
    % How many label columns are given
    
    segfile_len = length( seg_start );

    segments = zeros( segfile_len, num_labelCols+2 );
    
    % Fill out the labels corresponding to these times
    for i=1:num_labelCols
        segments(:,STOP+i) = seq(seg_stop,i);
    end

if length( seg_start ) > 0
    segments(:,START) = seg_start;
    segments(:,STOP) = seg_stop;    
end

% Remove any redundant labels
iKeep = segments(:,2)-segments(:,1) > 0;
segments = segments( iKeep, : );

if ~showZeroLabels
    labels = segments(:,LABELS);    
    segments = segments( labels~=0, :);
end

% Convert from the input times at sample_rate to the output in seconds
segments(:,[START,STOP]) = segments(:,[START,STOP]) * (1 / sample_rate) ;
 
