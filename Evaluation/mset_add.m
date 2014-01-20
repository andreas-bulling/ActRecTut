% combine mset results a and b : "a+b"
%
% note a and b must be complete mset structures, 
% i.e. including the .t, .e and .s components. 
%
% Copyright 2009 Jamie A. Ward
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

function tse = mset_add(a, b)

alen = length(a.t.T);
blen = length(b.t.T);

if (alen~=blen)
    error(' mset_add(a, b): matrix a and b must have the same dimensions!');
end

empt = mset_empty( alen );
t = empt.t;
s = empt.s;
e = empt.e;

        t.Conf = a.t.Conf +  b.t.Conf;
        t.ID = a.t.ID + b.t.ID;
        t.IU = a.t.IU + b.t.IU;
        t.IF = a.t.IF + b.t.IF;
        t.OD = a.t.OD + b.t.OD;
        t.OU = a.t.OU + b.t.OU;
        t.MD = a.t.MD + b.t.MD;
        t.T = a.t.T   + b.t.T;        
        
        s.Conf = a.s.Conf +  b.s.Conf;
        s.ID = a.s.ID + b.s.ID;
        s.IU = a.s.IU + b.s.IU;
        s.IF = a.s.IF + b.s.IF;
        s.OD = a.s.OD + b.s.OD;
        s.OU = a.s.OU + b.s.OU;
        s.MD = a.s.MD + b.s.MD;
        s.T = a.s.T   + b.s.T;      
 
%  e.T = a.e.T + b.e.T;
%  e.returnedT = a.e.returnedT + b.e.returnedT;
%  e.I = a.e.I + b.e.I ;
%  e.D = a.e.D + b.e.D ;
%  e.M = a.e.M + b.e.M ;
%  e.F = a.e.F + b.e.F ;
%  e.CF = a.e.CF + b.e.CF ;
%  e.CM = a.e.CM + b.e.CM ;
%  e.Corr = a.e.Corr  + b.e.Corr  ;
%  e.Short = a.e.Short  + b.e.Short  ;
%  e.Delay = a.e.Delay  + b.e.Delay  ;
%  e.Pre = a.e.Pre  + b.e.Pre  ;
%  e.Pro  = a.e.Pro  + b.e.Pro  ;
 
%  
 
    e.classes=a.e.classes;
    if ~isequal(a.e.classes, b.e.classes)
        warning('mset_add: classes in a and b do not match!');
    end

             e.eventLabel=[a.e.eventLabel b.e.eventLabel];
         e.nMatchesPerEvent =[a.e.nMatchesPerEvent b.e.nMatchesPerEvent ];
                  e.nDel =[a.e.nDel b.e.nDel ];
    e.nInsertedFragments =[a.e.nInsertedFragments b.e.nInsertedFragments ];
                e.nDelay =[a.e.nDelay b.e.nDelay ];
                e.nShort =[a.e.nShort b.e.nShort ];
            e.nUnderfill =[a.e.nUnderfill b.e.nUnderfill ];
             e.predLabel =[a.e.predLabel b.e.predLabel ];
          e.nMatchesPerReturn =[a.e.nMatchesPerReturn b.e.nMatchesPerReturn ];
                  e.nIns =[a.e.nIns b.e.nIns ];
         e.nMergeDeleted =[a.e.nMergeDeleted b.e.nMergeDeleted ];
              e.nPreempt =[a.e.nPreempt b.e.nPreempt ];
              e.nProlong =[a.e.nProlong b.e.nProlong ];
             e.nOverfill =[a.e.nOverfill b.e.nOverfill]; 
             e.eventPartOfMerge =[a.e.eventPartOfMerge b.e.eventPartOfMerge];             
             
             e.returnPartOfFragmented = [a.e.returnPartOfFragmented b.e.returnPartOfFragmented];
             
%            e.TotalEvents =a.e.TotalEvents + b.e.TotalEvents ;
%          e.DeletedEvents =a.e.DeletedEvents + b.e.DeletedEvents;
%       e.FragmentedEvents =a.e.FragmentedEvents + b.e.FragmentedEvents;
%       e.AvgFragmentCount =a.e.AvgFragmentCount + b.e.AvgFragmentCount ;
%       e.StdFragmentCount =a.e.StdFragmentCount + b.e.StdFragmentCount ;
%          e.DelayedEvents =a.e.DelayedEvents + b.e.DelayedEvents ;
%        e.ShortenedEvents =a.e.ShortenedEvents + b.e.ShortenedEvents ;
%      e.UnderfilledEvents =a.e.UnderfilledEvents + b.e.UnderfilledEvents ;
%           e.TotalReturns =a.e.TotalReturns + b.e.TotalReturns ;
%        e.InsertedReturns =a.e.InsertedReturns + b.e.InsertedReturns ;
%         e.MergingReturns =a.e.MergingReturns + b.e.MergingReturns ;
%          e.AvgMergeCount =a.e.AvgMergeCount + b.e.AvgMergeCount ;
%          e.StdMergeCount =a.e.StdMergeCount + b.e.StdMergeCount ;
%      e.PreemptiveReturns =a.e.PreemptiveReturns + b.e.PreemptiveReturns ;
%       e.ProlongedReturns =a.e.ProlongedReturns + b.e.ProlongedReturns ;
%      e.OverfilledReturns =a.e.OverfilledReturns + b.e.OverfilledReturns ;
    
     
 tse.t = t;
 tse.s = s;
 tse.e = e;
 
 