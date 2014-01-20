% [r, lab, predT, gndT] = mset_segments( pred, ground, varargin )
%
%  Categorises each contiguous segment 
%  written by Jamie Ward, 2005
%  * update July 20th, 2008
%
% input: 
% pred, ground = [start_time stop_time label]
%             with all labels mapped contiguously onto
%             0*,1,2,3,..
%
% Any times which are not explicitly covered by a label (e.g. between
% segments) is regarded as NULL. This is automatically assigned the label 0. 
% Note: specify 'NULL_ONE', if labelling uses 1 for NULL.
% All outputs -lab, predT and gndT will use '1' for NULL.
%
% By default the evaluation covers sample 1 until the last stop_time in
% the ground truth
%
% Note: if events are not strictly contiguous, an error is returned.
% 
% output
% --------
% output: [r, lab] 
%
% r=[seg_start_time seg_end_time error_code event_code] == label to segment mapping 
%  where error_code corresponds to the following error pairings:
%   0 = Match
%  18 = ID
%  20 = IU
%  24 = IF
%  34 = OD
%  36 = OU
%  66 = MD
%
% and event_code maps to: 
%   PERFECT MATCH = 0; 
%   8 = FRAG: segment is part of a fragmented event
%   64= MERGE: segment is part of a merged return
%   72= FRAG+MERGE: segment is part of both a fragmented event and a merged return
%
% lab = [pred_label ground_label] for each segment in r
%
% gndT = a list of all ground truth event stop times (column 1 and their labels)
%
% Copyright Jamie A. Ward
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

function [r, lab, predT, gndT] = mset_segments( pred, ground, varargin );

NLL=0;
if ~isempty(varargin)
    for n=1:length(varargin)
        
      if isstr(varargin{n})        
        str = lower(varargin{n});        
        if findstr(str,'null_one')                
            NLL=1;            
        end
      end
    end
end
IN_NULLVAL = NLL;

if NLL==0
    % Shift all labels so that NULL (assumed to be 0) is moved to '1'  
    pred(:,3)=pred(:,3)+1;      
    ground(:,3)=ground(:,3)+1; 
    NLL=1;     
end

if isempty(ground)
    error('No ground truth defined');
end
if isempty(pred)
    pred(1,:) = [ground(1,1) ground(end,2) NLL];    
end

% Check that inputs are strictly contiguous
if sum(pred(2:end,1) - pred(1:end-1,2) < 0)
    error('Prediction events are not contiguous.');
end
if sum(ground(2:end,1) - ground(1:end-1,2) < 0)
    error('Ground truth events are not contiguous.');
end

MATCH = 0; 
DEL = 2^1; % 2
UNDER = 2^2; % 4
FRAG = 2^3; % 8
INS = 2^4; % 16
OVER = 2^5; % 32
MERGE = 2^6; % 64

% remove any empty segments
iRemove = (pred(:,2) - pred(:,1)) <= 0;
pred(iRemove,:) = [];
iRemove = (ground(:,2) - ground(:,1)) <= 0;
ground(iRemove,:) = [];

% Divide into segments
% 1. merge pred and ground into a single sorted column of event stop times 
% but preserve combination of associated labels.

% Ground
% Make segment times into a single column, i.e.[start1 stop1 start2 stop2]'
gndT=ground(:,1:2)';
gndT=gndT(:);
gndT(:,2)=ones(length(gndT),1);
gndT(2:2:end,2) = ground(:,3) ; % add the labels - mark label corresponding to stop time!

 % Remove zero length segments 
 nonzero = [ 1 ; find( 0~= gndT(2:end,1) - gndT(1:end-1,1) ) + 1];
 gndT=gndT(nonzero,:);

nGndT=size(gndT,1);

% Merge consecutive segments where there is no change
keep=[];
for i=1:nGndT-1
    now = gndT(i,2:end);
    next = gndT(i+1,2:end);    
    if now==next
        % remove now.
    else
        keep = [keep; i];
    end
end
keep=[keep; nGndT]; 
gndT=gndT(keep,:);
nGndT=size(gndT,1);

% Predictions
if isempty(pred)
    predT(1,1:2) = [0 NLL];
else
    predT=pred(:,1:2)';
    predT=predT(:);
    predT(:,2)=ones(length(predT),1);
    predT(2:2:end,2) = pred(:,3) ; % add the labels
end
 % Remove zero length segments 
 nonzero = [ 1 ; find( 0~= predT(2:end,1) - predT(1:end-1,1) ) + 1];
 predT=predT(nonzero,:);
nPredT = size(predT,1);

% Merge consecutive segments where there is no change
keep=[];
for i=1:nPredT-1
    now = predT(i,2:end);
    next = predT(i+1,2:end);    
    if now==next
        % remove now.
    else
        keep = [keep; i];
    end
end
keep=[keep; nPredT]; 
predT=predT(keep,:);
nPredT=size(predT,1);


% Ensure prediction and ground have the same length
if gndT(end,1) > predT(end,1)   
    
    % prediction ends before ground truth
    if predT(end,2)==NLL
        predT(end,1)= gndT(end,1);
    else
        predT = [predT; [gndT(end,1) NLL]];
    end
 elseif gndT(end,1) < predT(1,1)
     % ground truth ends before prediction starts    
     % -> truncate prediction sequence. 
     predT = [gndT(end,1) NLL];
    
 elseif gndT(end,1) < predT(end,1)
     % ground truth ends before prediction     
     % => Truncate predictions to final ground truth.
     i=length(predT)-1;
     while gndT(end,1) < predT(i,1) 
         i=i-1;
     end
     if predT(i,1)==gndT(end,1)
         predT = predT(1:i,:);
     else               
         predT = predT(1:i+1,:);
         predT(i+1,1) = gndT(end,1);
     end
 
else
    % Ok.
end
[nGnd, col] = size( gndT );
[nPred, col] = size( predT );

% Change the label columns to represent [stopTime groundL predL]
gndT(:,3) = (-1)*ones(nGnd,1);
predT(:,3) = predT(:,2);
predT(:,2) = (-1)*ones(nPred,1);

% Now merge both.
segT = [gndT;predT];
[segT(:,1), iSegT] = sort(segT(:,1)); % sort only according to timing
segT(:,2:3) = segT(iSegT, 2:3); % Re assign labels
nSegT = size(segT,1);

% The beginning time is always one (with class null)
segT = [0 NLL NLL; segT];

% spread the labelling where necessary - spread backwards from marked
% .. because a label is first mentioned at the _end_ of its segment.
for idx= nSegT:-1:1
   gL = segT(idx+1,2); % Current gnd label
   pL = segT(idx+1,3); % Current pred label    
   mergeSeg = (segT(idx+1,1)-segT(idx,1) == 0); % Zero length segment
   
   if mergeSeg==true
       % Zero length segment, so merge both entries
       % to swamp out any '-1's
       if segT(idx,2) > -1
           gL=segT(idx,2);
       end
       if segT(idx,3) > -1
           pL=segT(idx,3);
       end
      segT(idx:idx+1, 2) = gL;
      segT(idx:idx+1, 3) = pL;
   end   
   
   % Usually at the end of the segment file, no more information: set to
   % null.
   if gL == -1
      segT(idx+1,2) = NLL;
   end
   if pL == -1
      segT(idx+1,3) = NLL;
   end
   
   % Now set preceeding labels
   if (segT(idx,2) == -1) 
       segT(idx,2) = gL; 
   end
   
   if (segT(idx,3) == -1) 
       segT(idx,3) = pL;
   end
      
end

% Remove zero length segments 
nonzero = [ 1 ; find( 0~= segT(2:end,1) - segT(1:end-1,1) ) + 1];
segT=segT(nonzero,:);

nSegT=size(segT,1); % Re-evaluate length

% Merge consecutive segments where there is no change
keep=[1];
for i=2:nSegT-1
    now = segT(i,[2 3]);
    next = segT(i+1,[2 3]);    
    if now==next
        % remove now.
    else
        keep = [keep; i];
    end
end
keep=[keep; nSegT];
segT=segT(keep,:);

nSegT=size(segT,1); % Re-evaluate length
segEtype = zeros(nSegT,2);

% Go through all the ground truth events
start = 0;
for i = 1:nGnd;
   stop = gndT(i);
   % Find index of all segments within this event
   isegs = find( start < segT(:,1) & segT(:,1) <= stop );
   % Find index of all matching segments
   isegsmatch = isegs( segT(isegs,2)==segT(isegs,3) );
   
   if isempty(isegsmatch)
     % All segments within this event are deletions
     segEtype(isegs,1) = segEtype(isegs,1) + DEL;     
   else
     % Any segments occurring before the first or after the last match is an underfill
     iunderfillsegs = [isegs(isegs < isegsmatch(1)); isegs(isegs > isegsmatch(end))];
     if ~isempty(iunderfillsegs)
         segEtype(iunderfillsegs,1) = segEtype(iunderfillsegs,1) + UNDER;     
     end
     
     fragFlag = 0;
     % Any segments occurring between correctly matched segments of the
     % same event is a fragmenting error
     inonfragsegs = [isegsmatch; iunderfillsegs];
     for n=1:length(isegs)
         if isempty( find(isegs(n)==inonfragsegs) );
             segEtype(isegs(n),1) = segEtype(isegs(n),1) + FRAG;             
             fragFlag = 1;
         end
     end
        
     if fragFlag
        % mark all segments as being part of a fragmented event
         segEtype(isegs,2) = segEtype(isegs,2) + FRAG;
     end
     
   end
   start = stop;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Go through all the prediction events
start = 0;
for i = 1:nPred;
   stop = predT(i); 
   % Find index of all segments within this event
   isegs = find( start < segT(:,1) & segT(:,1) <= stop );
   % Find index of all matching segments
   isegsmatch = isegs( segT(isegs,2)==segT(isegs,3) );
   
   if isempty(isegsmatch)
     % All segments within this event are insertions
     segEtype(isegs,1) = segEtype(isegs,1) + INS;     
   else
     % Any segments occurring before the first or after the last match is
     % an overfill
     iunderfillsegs = [isegs(isegs < isegsmatch(1)); isegs(isegs > isegsmatch(end))];
     if ~isempty(iunderfillsegs)
         segEtype(iunderfillsegs,1) = segEtype(iunderfillsegs,1) + OVER;     
     end
     
     mergeFlag=0;
     % Any segments occurring between correctly matched segments of the
     % same event is a merger error
     inonfragsegs = [isegsmatch; iunderfillsegs];     
     for n=1:length(isegs)
         if isempty( find(isegs(n)==inonfragsegs) );
             segEtype(isegs(n),1) = segEtype(isegs(n),1) + MERGE;             
             mergeFlag = 1;
         end
     end

     % mark all segments as being part of a merging return
     if mergeFlag
        segEtype(isegs,2) = segEtype(isegs,2) + MERGE;
     end
     
   end
   start = stop;
end


%%%%%
% Convert back into standard segment format
startT = segT(1:end-1,1);
% remove the unwanted first row from 'stopT'
segmentResults = [startT segT(2:end,:) segEtype(2:end,:)];
r=segmentResults(:,[1 2 5 6]);
% corresponding ground and prediction labels
lab=segmentResults(:,[3 4]);

gndT=gndT(:,[1 2]);
predT=predT(:,[1 3]);
