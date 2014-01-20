% function r=mset_metrics( m, varargin )
%
% return a structure with a number of useful metrics based on mset 
%
%
% argument pair: 'null', [class_list]
% allows a list of classes to be specified. Otherwise the FIRST class is
% assumed to be NULL
%
%
% Dealing with empty ground truth inputs 
%   -> if there are no Positive classes: 
%           recall, precision == 1
%           fnr, npv == 0
%   -> if there are no Negative classes:
%           tm, specificity == 1
%           fpr == 0
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

function r=mset_metrics( m, varargin )

iN=1;
if ~isempty(varargin)
    for n=1:2:length(varargin)        
        if findstr(varargin{n},'null')                
            iN=varargin{n+1};
        end
    end
end



nClasses=length(m.t.T);
iP=1:nClasses;
iP(iN)=[];

r.t = conf_res(m.t.Conf, iP, iN);
r.s = conf_res(m.s.Conf, iP, iN);

r.t.multi_mset = mset_res( m.t, iP, iN );
r.s.multi_mset = mset_res( m.s, iP, iN );

for iClass = 1:nClasses
    iNotClass = 1:nClasses;
    iNotClass(iClass)=[];
    r.t.multi_bin_mset(iClass) = mset_res( m.t, iClass, iNotClass );
    r.s.multi_bin_mset(iClass) = mset_res( m.s, iClass, iNotClass );
end

% add some additional info
r.t.mset = m.t;
r.s.mset = m.s;
r.e.mset = m.e;

r.e = mset_event_metrics( m.e, iP, iN );



function y = mset_res( x, Pgrp, Ngrp )
    %  multiclass vs. null

    correctC = diag(x.Conf);           
    incorrectC = triu(x.Conf,1)+tril(x.Conf,-1);
    
    y.N = sum(sum( x.Conf(:,Ngrp) ));
    y.P = sum(sum( x.Conf(:,Pgrp) ));
    y.reportedN = sum(sum( x.Conf(Ngrp,:) ));
    y.reportedP = sum(sum( x.Conf(Pgrp,:) ));
        
    N=y.N;
    P=y.P;
        
    y.correctP = sum(correctC(Pgrp));
    y.correctN = sum(correctC(Ngrp));
    
    y.Del = sum( [sum(sum(x.ID(Ngrp,Pgrp))) sum(sum(x.OD(Ngrp,Pgrp))) sum(sum(x.MD(Ngrp,Pgrp)))] );
    y.Und = sum( [sum(sum(x.IU(Ngrp,Pgrp))) sum(sum(x.OU(Ngrp,Pgrp)))] );
    y.Fra = sum(  sum(x.IF(Ngrp,Pgrp)) );
    
    y.Ins = sum( [sum(sum(x.ID(Pgrp,Ngrp))) sum(sum(x.IU(Pgrp,Ngrp))) sum(sum(x.IF(Pgrp,Ngrp)))] );
    y.Ove = sum( [sum(sum(x.OD(Pgrp,Ngrp))) sum(sum(x.OU(Pgrp,Ngrp)))] );
    y.Mer = sum(  sum(x.MD(Pgrp,Ngrp)) );
 

    % Substitutions
    y.substitution = sum( sum(incorrectC(Pgrp,Pgrp)) );                      
    
    y.sID = sum(sum(x.ID(Pgrp,Pgrp)));
    y.sIU = sum(sum(x.IU(Pgrp,Pgrp)));
    y.sIF = sum(sum(x.IF(Pgrp,Pgrp)));
    y.sOD = sum(sum(x.OD(Pgrp,Pgrp)));
    y.sOU = sum(sum(x.OU(Pgrp,Pgrp)));
    y.sMD = sum(sum(x.MD(Pgrp,Pgrp)));

    
    % mset based rates
    if N > 0    
        y.tnr = sum(sum(x.Conf(Ngrp,Ngrp))) / N;                  
        y.fpr = (y.Ins + y.Mer + y.Ove) / N;
        y.fp_ir = y.Ins / N;
        y.fp_mr = y.Mer / N;
        y.fp_or = y.Ove / N;
    else
        y.tnr = 1;
        y.fpr = 0;
        y.fp_ir = 0;
        y.fp_mr = 0;
        y.fp_or = 0;
    end
    
    
    if y.reportedP > 0    
        % These metrics are components of (1-precision)
        y.fppv =  (y.Ins + y.Mer + y.Ove) / y.reportedP; % false positive prediction value    
        
    else
        y.fppv =  0;        
    end
    
    if P > 0    
        y.tpr = sum(sum(x.Conf(Pgrp,Pgrp))) / P;  
        y.fnr = (y.Del + y.Fra + y.Und) / P;
    
        y.fn_dr = y.Del / P;
        y.fn_fr = y.Fra / P;
        y.fn_ur = y.Und / P;
        y.sr = y.substitution / P; 
    else
        y.tpr = 1;
        y.fnr = 0;
        y.fn_dr = 0;
        y.fn_fr = 0;
        y.fn_ur = 0;
        y.sr = 0;
    end
        
function r = conf_res( C, iP, iN )        

           correctC = diag(C);           
           incorrectC = triu(C,1)+tril(C,-1);
           gndTotal = sum(C,1);
           predTotal = sum(C,2);
           
           % ensure no division by zero
           gndTotal( gndTotal==0 ) = realmin;
           predTotal( predTotal==0 ) = realmin;           
                      
           total = sum(gndTotal);
           
           r.total = total;
           r.correctC = correctC;           
           r.recallC=0;
           r.precisionC=0;                                 
           r.recallC = correctC ./ gndTotal';           
           r.precisionC = correctC ./ predTotal;           
                                 
           r.iP = iP;
           r.iN = iN;
           
           Pos = sum(gndTotal(iP));
           Neg = sum(gndTotal(iN));
           PosPred = sum(predTotal(iP));
           NegPred = sum(predTotal(iN));
           
           
           correctP = correctC(iP); 
           correctN = sum( sum( C(iN,iN) ) ); 
           
           r.correctP = correctP;
           r.correctN = correctN;           
           r.falseP = predTotal(iP) - correctP;
           %r.falseN = sum( predTotal(iN)  - sum( C(iN,iN), 2) );
                      
          % summed results
           %r.TP = sum(correctP);
           %r.TN = sum(correctN);                               
           %r.FP = sum(r.falseP) ;            
           %r.FN = sum(r.falseN);

           r.recall = sum(r.correctP) ./ Pos;
           r.precision = sum(r.correctP) ./ PosPred;
           r.fpr = sum(r.falseP) ./ Neg;
           
           % overall result
           r.accuracy = sum([r.correctP; r.correctN]) ./ total;    

           beta = 1;
           r.f1score = (1 + beta^2) * (r.precision * r.recall) / (beta^2 * r.precision + r.recall);
           beta = 0.5;
           r.f05score = (1 + beta^2) * (r.precision * r.recall) / (beta^2 * r.precision + r.recall);
           beta = 2;
           r.f2score = (1 + beta^2) * (r.precision * r.recall) / (beta^2 * r.precision + r.recall);
           
           r.recallP = [r.correctP] ./ gndTotal(iP)';           
           r.precisionP = [r.correctP] ./ predTotal(iP);           
           r.recallN = r.correctN ./ sum(gndTotal(iN));
           r.precisionN = r.correctN ./ sum(predTotal(iN));
                                 
           r.avgRecall    = mean( [r.recallP ; r.recallN ]);
           r.avgPrecision = mean( [r.precisionP ; r.precisionN ]);
                     
           
           % binary results (positive vs. null)
           TP = sum(sum( C(iP, iP) )); %sum(correctC(iP));
           TN = sum(sum( C(iN, iN) )); %sum(correctC(iN));                               
           FP = sum(sum( C(iP, iN) ));           
           FN = sum(sum( C(iN, iP) ));
                      
           r.binary_TP = TP;
           r.binary_FP = FP;           
           r.binary_TN = TN;
           r.binary_FN = FN;           
           r.binary_accuracy = (TP + TN) / total;
           
           if TP+FP == 0
            r.binary_recall = 1;
            r.binary_precision = 1;
           else
            r.binary_recall = TP ./ (TP + FN);
            r.binary_precision = TP ./ (TP + FP);   
           end
           
           if TN+FP == 0
            r.binary_fp = 0;
           else
            r.binary_fp = FP ./ (FP + TN);
           end                  
           
           
           
           
%%%%%%%% EVENT BASED METRICS           
function y = mset_event_metrics( e, Pgrp, Ngrp )

% Calculate the statistics
for cl = e.classes
        
    %% Prediction
    iClass = find( e.predLabel==cl );    
    e.TotalReturns(cl) = length( iClass );    
    e.InsertedReturns(cl) = sum( e.nIns(iClass) > 0 );
    e.MergingReturns(cl) = sum( e.nMergeDeleted(iClass) > 0 );
    
    e.PreemptiveReturns(cl) = sum( e.nPreempt(iClass) > 0);
    e.ProlongedReturns(cl) = sum( e.nProlong(iClass) > 0);
    e.OverfilledReturns(cl) = sum( e.nOverfill(iClass) > 0);            
    
    pre = e.nPreempt(iClass) ; %initial... 
    pre = 0 - pre( pre > 0 );
    
    pro = e.nProlong(iClass) ;  %initial...
    pro = pro( pro > 0 );
    
    %%%%%       
    % Select only merged events
    iMatchMerge = iClass( find( e.nMatchesPerReturn(iClass) > 1 )) ;    
    if ~isempty(iMatchMerge)        
        % Average counts of the matching events over all predictions
        e.AvgMergeCount(cl) = mean( e.nMatchesPerReturn( iMatchMerge ) );         
        e.StdMergeCount(cl) = std( e.nMatchesPerReturn( iMatchMerge ) );
    else        
        e.AvgMergeCount(cl) = 0;
        e.StdMergeCount(cl) = 0;
    end

    e.ReturnFragments(cl) = sum( (e.returnPartOfFragmented(iClass) > 0) );
    
% New combined categories based on returns (r) 
e.re(cl).returns = e.TotalReturns(cl);
e.re(cl).FrMr = sum( (e.nMatchesPerReturn(iClass) > 1) & (e.returnPartOfFragmented(iClass) > 0) );
e.re(cl).Fr = e.ReturnFragments(cl) - e.re(cl).FrMr;
e.re(cl).Mr = e.MergingReturns(cl) - e.re(cl).FrMr;
e.re(cl).I = e.InsertedReturns(cl);    
Cr(cl) = e.re(cl).returns - e.re(cl).I - e.re(cl).FrMr - e.re(cl).Mr - e.re(cl).Fr;
    
        
    %% Ground truth
    iClass = find( e.eventLabel==cl );    
    e.TotalEvents(cl) = length( iClass );    
    e.DeletedEvents(cl) = sum( e.nDel(iClass) > 0 );    
   
    % e.FragmentedEvents(cl) = sum( e.nInsertedFragments(iClass) > 0  );    
    % This is not true. Several different inserted fragments could appear consecutively. 
    % Use match count instead...
        
    % Select only fragmented events
    iMatchFrag = iClass( find( e.nMatchesPerEvent(iClass) > 1 ) );  
    if ~isempty(iMatchFrag)
        e.FragmentedEvents(cl) = length( iMatchFrag );
        % Average counts of matches over all events
        e.AvgFragmentCount(cl) = mean( e.nMatchesPerEvent( iMatchFrag ) ); 
        e.StdFragmentCount(cl) = std( e.nMatchesPerEvent( iMatchFrag ) );
    else
        e.FragmentedEvents(cl) = 0;
        e.AvgFragmentCount(cl) = 0; 
        e.StdFragmentCount(cl) = 0;
    end
    
    e.MergedEvents(cl) = sum( (e.eventPartOfMerge(iClass) > 0) );
    
    e.DelayedEvents(cl) = sum( e.nDelay(iClass) > 0 );
    e.ShortenedEvents(cl) = sum( e.nShort(iClass) > 0 );
    e.UnderfilledEvents(cl) = sum( e.nUnderfill(iClass) > 0);          
    
    %! NEEDS FIXING: need to include correct no-timing error instances
    delay = e.nDelay(iClass);
    delay = [delay(delay>0) pre]; 
    if ~isempty(delay)
        e.AvgDelay(cl) = mean( delay );
        e.StdDelay(cl) = std( delay );
    else
        e.AvgDelay(cl) = 0;
        e.StdDelay(cl) = 0;
    end
    
    % New categories based on returns (r) 
e.re(cl).D = e.DeletedEvents(cl);
e.re(cl).FeMe = sum( (e.eventPartOfMerge(iClass) > 0) & (e.nMatchesPerEvent(iClass) > 1) );
e.re(cl).Me = e.MergedEvents(cl) - e.re(cl).FeMe;
e.re(cl).Fe = e.FragmentedEvents(cl) - e.re(cl).FeMe;
e.re(cl).events =  e.TotalEvents(cl);
e.re(cl).C = e.re(cl).events - e.re(cl).D - e.re(cl).FeMe - e.re(cl).Me - e.re(cl).Fe;
% check!
if ( e.re(cl).C ~= Cr(cl) )
% Commented out, Andreas, 06 January 2011
%    disp('eBug: e.re(cl).C  does not match for events and returns');
end


    
    %! NEEDS FIXING: need to include correct no-timing error instances
    short = e.nShort(iClass);
    short = [pro (0-short(short>0))];
    if ~isempty(short)
        e.AvgExtension(cl) = mean( short );
        e.StdExtension(cl) = std( short );
    else
        e.AvgExtension(cl) = 0;
        e.StdExtension(cl) = 0;
    end
    
%     td = e.DelayedEvents(cl) + e.PreemptiveReturns(cl) ;
%     if td>0
%         e.AvgDelay(cl) = e.AvgDelay(cl) + sum( e.nDelay(iClass) ) ./ td;
%     else
%         e.AvgDelay(cl) = 0;
%     end
%     te = e.ProlongedReturns(cl) + e.ShortenedEvents(cl); 
%     if te>0
%         e.AvgExtension(cl) = e.AvgExtension(cl) - sum( e.nShort(iClass) ) ./ te;
%     else
%          e.AvgExtension(cl) = 0;
%     end

end


y = e;


% T= x.T;
% D= x.D;
% I= x.I;
% F= x.F;
% M= x.M;
% %C= x.T - c.D - x.CM;  % still includes fragmented events..
% CM=x.CM;
% CF=x.CF;
% 
% retP = x.returnedT;
% 
% P= T;
% % for i=1:length(T)
% %    Tnoi = T;
% %    Tnoi(i) = [];
% %    N(i)= sum( Tnoi );
% % end
% 
% y.P = P;
% y.retP = retP;
% 
% if P > 0 
%  %   y.Cr = C ./ P;
%     y.Dr = D ./  P;
%     y.CMr = CM ./ P;
% else
%     y.Cr = 1;
%     y.Dr = 0;
%     y.CMr = 0;
% end
% 
% if retP > 0
%     y.Ir = I ./  retP;
%     y.CFr = CF ./ retP;
% else
%     y.Ir = 0;
%     y.CFr = 0;
% end
% 
