% function tse = mset_empty(nClasses)
% return an empty mset result
% tse.t, tse.s and tse.e
% with e.g. tse.t.Conf=[0 0 ...; 0 0 ...; ..]%
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

function tse = mset_empty(nClasses)

M = zeros(nClasses);
V = zeros(nClasses,1);

 t.axestext = 'output predictions(rows) x ground truth(columns)';

 t.Conf = M;
 t.ID = M;
 t.IU = M;
 t.IF = M;
 t.OD = M;
 t.OU = M;
 t.MD = M;
 t.T = V';
 
%  t.CM = M;
%  t.CF = M;
  
%  e.T = V;
%  e.I = V;
%  e.D = V;
%  e.M = V;
%  e.F = V;
%  e.Corr = V;
%  e.Short = V;
%  e.Delay = V;
%  e.Pre = V;
%  e.Pro  = V;

        e.classes = 1:nClasses;

            e.eventLabel = [];
      e.nMatchesPerEvent = [];
                  e.nDel = [];
    e.nInsertedFragments = [];
                e.nDelay = [];
                e.nShort = [];
            e.nUnderfill = [];
      e.eventPartOfMerge = [];            
             e.predLabel = [];
     e.nMatchesPerReturn = [];
                  e.nIns = [];
         e.nMergeDeleted = [];
              e.nPreempt = [];
              e.nProlong = [];
             e.nOverfill = [];
e.returnPartOfFragmented = [];
             
%            e.TotalEvents = 0;
%          e.DeletedEvents = 0;
%       e.FragmentedEvents = 0;
%       e.AvgFragmentCount = 0;
%       e.StdFragmentCount = 0;
%          e.DelayedEvents = 0;
%        e.ShortenedEvents = 0;
%      e.UnderfilledEvents = 0;     
%       
%      e.TotalReturns = 0;
%        e.InsertedReturns = 0;
%         e.MergingReturns = 0;
%          e.AvgMergeCount = 0;
%          e.StdMergeCount = 0;                
%      e.PreemptiveReturns = 0;
%       e.ProlongedReturns = 0;
%      e.OverfilledReturns = 0;
 
 
 tse.t = t;
 tse.s = t;
 tse.e = e;