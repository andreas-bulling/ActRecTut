% out = mset(pred, ground, varargin)
%
% continuous context evaluation method which
% fills out a Multiclass Segment Error Table (SET)
%
% input: 
% pred, ground = [start_time stop_time label]
%             with all labels mapped contiguously onto
%             0*,1,2,3,..
%
%   Important: events should not overlap in time.
%
% varargin options
% ----------------
% 'NULL_ONE'
% Any times which are not explicitly covered by a label (e.g. between
% segments) is automatically assigned the label 0 (NULL).
% If you wish to use label 1 for NULL then set varargin='NULL_ONE'. (This
% effectively groups labels 1 and 0.)
%
% 'nClasses', nClasses
% The default number of classes is taken from the ground and prediction
% information, however if
% these inputs do not contain representatives of all classes, then you can
% specify, for example: 'nClasses', number  (note: includes NULL class)
%
% 'GROUND_LEN', groundLen
% By default the evaluation covers sample 1 until the last stop_time in the
% ground truth. However, the evaluation time can be extended (or shortened)
% explicitly by stating 'groundLen', groundLen.
% for groundLen > ground stop_time, the ground will be extended by NULL labels.
%
% output
% --------
% output (out.t, out.s, out.e): 
% out.t== time based result 
% out.s== segment result
%   .T = Total
%   .ID = Insertion Deletion, etc..
%   .IU
%   .IF
%   .OD
%   .OU
%   .MD
%   .Conf - regular confusion matrix ()
%
%   .CM
%   .CF
%   .C
%
% out.e==event based result
% % .T = total
% % .I, .D, .M, .F
% % .CM = number of correct events involved in a merge
% % .CF = number of correct predictions within a fragmented event
% % (e. also has event timing errors) 
% % .Pre = preemption (overfill)
% % .Pro = prolongation (overfill)
% % .Short = shortening (underfill)
% % .Delay = delay (underfill)
%
%
%%%%%%%%%%%%%%%
% Uses: mset_segments.m
%
% Copyright 2005-2008 Jamie A. Ward
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

function out = mset( pred, ground, varargin );

NLL=0;
nClasses=0;
groundLen=0;

if ~isempty(varargin)
    for n=1:length(varargin)
        
      if isstr(varargin{n})
        
        str = lower(varargin{n});
        
        if findstr(str,'null_one')                
            NLL=1;
        end

        if findstr(str,'nclasses')
            if length(varargin)==n
                error('nClasses needs an argument');
            end
            nClasses=varargin{n+1};
        end
        
        if findstr(str,'ground_len') | findstr(str,'groundlen')
            if length(varargin)==n
                error('groundLen needs an argument');
            end
            groundLen=varargin{n+1};                                     
        end
        
      end
    end
end
    
% Ensure that there is a ground truth.
if isempty(ground)    
    if groundLen == 0 
        error('Neither ground truth nor groundLen specified.');
    else
        ground = [0 groundLen NLL]; 
    end
   
elseif groundLen > 0 
    % Need to adjust the ground truth according to groundLen parameter.
    [gc,gr] = find(ground(:,[1 2])' > groundLen );    
    if isempty(gc)
        % create a new ending segment for ground
        ground(end+1,:) = [ground(end,2) groundLen NLL];
    else
        % truncate the ground truth                 
        gc=gc(1); gr=gr(1);        
        if gc==1
            if gr(1)==1
                ground(gr,:) = [0 groundLen NLL]; 
            elseif ground(gr-1,2) < groundLen                
                ground(gr,:) = [ground(gr-1,2) groundLen NLL]; 
            else
                gr=gr-1;
            end            
        else                               
            ground(gr,2) = groundLen;
        end
        ground = ground(1:gr, :);
    end              
end


if isempty(pred)
    warning('No prediction - assuming NULL result.');
    pred(1,:) = [ground(1,1) ground(end,2) NLL];    
end

% Calculate the segments and mset error pairs 
if NLL==0
    [r lab predT gndT] = mset_segments( pred, ground );        
else   
    [r lab predT gndT] = mset_segments( pred, ground, 'NULL_ONE' );    
end
segD = r(:,2)-r(:,1);

nClasses = max( [nClasses; max( max(lab) )] );

% initialise the outputs
tmp = mset_empty(nClasses);
t=tmp.t; 
s=tmp.s;
e=tmp.e;

% error codes from mset_segments
MATCH = 0;
DEL = 2^1; % 2
UNDER = 2^2; % 4
FRAG = 2^3; % 8
INS = 2^4; % 16
OVER = 2^5; % 32
MERGE = 2^6; % 64
ID = INS+DEL; %18;
IU = INS+UNDER; %20;
IF = INS+FRAG; %24;
OD = OVER+DEL; %34;
OU = OVER+UNDER; %36;
MD = MERGE+DEL; % 66;

FRAGMERGE = FRAG+MERGE; % 72


for n=1:length(segD)
    % read each segment info into the appropriate table
    grL = lab(n,1); prL = lab(n,2);
    switch(r(n,3))
        case ID
            t.ID(prL,grL) = t.ID(prL,grL) + segD(n);
            s.ID(prL,grL) = s.ID(prL,grL) + 1;
        case IU
            t.IU(prL,grL) = t.IU(prL,grL) + segD(n);
            s.IU(prL,grL) = s.IU(prL,grL) + 1;
        case IF
            t.IF(prL,grL) = t.IF(prL,grL) + segD(n);
            s.IF(prL,grL) = s.IF(prL,grL) + 1;
        case OD
            t.OD(prL,grL) = t.OD(prL,grL) + segD(n);
            s.OD(prL,grL) = s.OD(prL,grL) + 1;
        case OU
            t.OU(prL,grL) = t.OU(prL,grL) + segD(n);
            s.OU(prL,grL) = s.OU(prL,grL) + 1;
        case MD
            t.MD(prL,grL) = t.MD(prL,grL) + segD(n);
            s.MD(prL,grL) = s.MD(prL,grL) + 1;                        
        otherwise
            % Match
            % check if part of a merge or fragmentation
%! Unclear what to do with the case where both occur 
%             switch r(n,4)
%                 case FRAG
%                     t.CF(prL,grL) = t.CF(prL,grL) + segD(n);
%                     s.CF(prL,grL) = s.CF(prL,grL) + 1;
%                 case MERGE
%                     t.CM(prL,grL) = t.CM(prL,grL) + segD(n);
%                     s.CM(prL,grL) = s.CM(prL,grL) + 1;
%                 case FRAGMERGE                    
%                               ????
%                 otherwise
%             end
            %disp(strcat(num2str(r(n,3)), num2str(prL),num2str(grL)));
    end

    % Fill out regular confusion matrix
    t.Conf(prL,grL) = t.Conf(prL,grL) + segD(n);
    s.Conf(prL,grL) = s.Conf(prL,grL) + 1;
end

% Overall sum
t.T = sum(t.Conf);
s.T = sum(s.Conf);

[nGnd, col] = size( gndT );
[nPred, col] = size( predT );


iMatchSegmentPartOfMerge = zeros(size(r(:,1)));

% Go through all the prediction returns
start=0;
for i = 1:nPred;    
    stop = predT(i);
    e.predLabel(i) = predT(i,2);
    
    if stop-start > 0
        % Find index of all event segments within this return
        isegs = find( start < r(:,2) & r(:,2) <= stop );        
        
        % Count the number of Matches or merge deletions, or whether the return is an insertion        
        iMatches = find( r(isegs,3)==MATCH );
        e.nMatchesPerReturn(i) = length( iMatches )';          
        e.nIns(i) = sum( r(isegs,3)==ID )' + sum( r(isegs,3)==IU )' + sum( r(isegs,3)==IF )';
        e.nMergeDeleted(i) = sum( r(isegs,3)==MD )';
                      
%         % flag if this return is part of a fragmented event
%         e.nPartOfFrag(i) = 0;
%         if (bitand(r(isegs(1),4), FRAG) == FRAG)
%             e.nPartOfFrag(i) = 1;
%         end
        
        % Count the timing errors. Underfill: delay and/or shortening         
        e.nPreempt(i)= sum(( r(isegs(1),3) == OD )' + ( r(isegs(1),3) == OU )');
        if e.nPreempt(i)
            e.nPreempt(i) = r(isegs(1),2) - r(isegs(1),1);
        end
        e.nProlong(i)= sum(( r(isegs(end),3) == OD )' + ( r(isegs(end),3) == OU )');
        if e.nProlong(i)
            e.nProlong(i) = r(isegs(end),2) - r(isegs(end),1);
        end
        e.nOverfill(i) = e.nPreempt(i) + e.nProlong(i);        
               
        if e.nMatchesPerReturn(i) > 1
            % Flag the matching segments if this return is a merge event 
            iMatchSegmentPartOfMerge( isegs(iMatches) ) = 1;
        end
                
    end
    start=stop;    
end

% Go through all the ground truth events
iMatchSegmentPartOfFragmented = zeros(size(r(:,1)));
start=0;
for i = 1:nGnd;
    stop = gndT(i);    
    e.eventLabel(i) = gndT(i,2);
    
    if stop-start > 0
        % Find index of all segments within this event
        isegs = find( start < r(:,2) & r(:,2) <= stop );        
                        
        % Count the number of Matches or false fragments, or whether the event has
        % been deleted.
        iMatches = find( r(isegs,3)==MATCH );
        e.nMatchesPerEvent(i) = length(iMatches)';
        e.nDel(i) = sum( r(isegs,3)==ID )' + sum( r(isegs,3)==MD )' + sum( r(isegs,3)==OD )';        
        e.nInsertedFragments(i) = sum( r(isegs,3)==IF )';        
        
%         % flag if this event is part of a merged return
%         e.nPartOfMerge(i) = 0;
%         if (bitand(r(isegs(1),4), MERGE) == MERGE)
%             e.nPartOfMerge(i) = 1;
%         end
        
        % Count the timing errors. Underfill: delay and/or shortening         
        e.nDelay(i)= sum(( r(isegs(1),3) == IU )' + ( r(isegs(1),3) == OU )');
        if e.nDelay(i)
            e.nDelay(i) = r(isegs(1),2) - r(isegs(1),1);
        end
        e.nShort(i)= sum(( r(isegs(end),3) == IU )' + ( r(isegs(end),3) == OU )');
        if e.nShort(i)
            e.nShort(i) = r(isegs(end),2) - r(isegs(end),1);
        end
        e.nUnderfill(i) = e.nDelay(i) + e.nShort(i);        
       
        % Finally determine whether any of the segments within this event
        % connect to a merging return (i.e. is this event merged with (an)other(s)?)
       
        mergePartEndTime = r(find(iMatchSegmentPartOfMerge),2);
        if ~isempty(mergePartEndTime)                        
            e.eventPartOfMerge(i)= sum( start < mergePartEndTime & mergePartEndTime <= stop );        
        else
            e.eventPartOfMerge(i)= 0;
        end
        
        % Jamie -- 12 Feb 2010
        if e.nMatchesPerEvent(i) > 1
            % Flag the matching segments if this event is fragmented
            iMatchSegmentPartOfFragmented( isegs(iMatches) ) = 1;
        end
        
    end
    start=stop;
end


% Go through all the prediction returns AGAIN
start=0;
for i = 1:nPred;    
    stop = predT(i);
    e.predLabel(i) = predT(i,2);
    
    if stop-start > 0
        % Find index of all event segments within this return
        isegs = find( start < r(:,2) & r(:,2) <= stop );        
        
        % Count the number of Matches or merge deletions, or whether the return is an insertion        
        iMatches = find( r(isegs,3)==MATCH );
            
        % Determine whether any of the segments within this event
        % connect to a fragmented event (i.e. does this return cause a fragment)       
        fragmentedPartEndTime = r(find(iMatchSegmentPartOfFragmented),2);
        if ~isempty(fragmentedPartEndTime)                        
            e.returnPartOfFragmented(i)= sum( start < fragmentedPartEndTime & fragmentedPartEndTime <= stop );        
        else
            e.returnPartOfFragmented(i)= 0;
        end
        
        
    end
    start=stop;
end




e.classes = 1:nClasses;

out.t=t;
out.e=e;
out.s=s;
