%   Plot chart(s) of mset data
%
% function [M handle]=plot_mset_errors(figureTitle, numArgs, chartType, varargin)
%
% numArgs - how many arguments to be expected for each data  (min 2)
% chartType - 'bar', 'fullpie, ,'twopie','DET'
%
% Input (numArgs)-tuples: 
%   Label1, msetData1, Label2, msetData2, etc.
% or Label1, msetData1, supplinfo1, ..
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

function [M handle]=plot_mset_errors(figureTitle, numArgs, chartType, varargin)

if numArgs<2
    disp('plot_mset_errors: numArgs should be >= 2');
    error(1);
end
%chartType='barconf'
chartype='bar full';
supp=[];data=[];label=[];
if ~isempty(varargin)
    j=1;
    if length(varargin)==1 & iscell(varargin{1})
        varargin=varargin{1};
    end
    for n=1:numArgs:length(varargin)-(numArgs-1)
        label{j} = varargin{n};
        data{j} = varargin{n+1};
        for i=3:numArgs
            supp{j,(i-2)} = varargin{n+(i-1)};
        end
        j=j+1;
    end
end

nSets=length(label);


for iSet=1:nSets % Gather all the data
    
    tm=data{iSet};
    % Sum up times over all files
    nFiles = length(tm);
    tID=0;tOD=0;tMD=0;tIU=0;tOU=0;tIF=0;tConf=0;tT=0;
    for i=1:nFiles
        tOD = tOD+tm(i).OD;
        tID = tID+tm(i).ID;
        tMD = tMD+tm(i).MD;
        tIU = tIU+tm(i).IU;
        tOU = tOU+tm(i).OU;
        tIF = tIF+tm(i).IF;
        tConf = tConf + tm(i).Conf;
        tT = tT + tm(i).T;
    end
    
    nClasses=length(tT);
    Ngrp=[1]; Pgrp=[2:nClasses];
    
    % w.r.t. Null
    Del(iSet) = sum( [sum(tID(Ngrp,Pgrp)) sum(tOD(Ngrp,Pgrp)) sum(tMD(Ngrp,Pgrp))] );
    Und(iSet) = sum( [sum(tIU(Ngrp,Pgrp)) sum(tOU(Ngrp,Pgrp))] );
    Fra(iSet) = sum(  sum(tIF(Ngrp,Pgrp)) );
    Ins(iSet) = sum( [sum(sum(tID(Pgrp,Ngrp))) sum(sum(tIU(Pgrp,Ngrp))) sum(sum(tIF(Pgrp,Ngrp)))] );
    Ove(iSet) = sum( [sum(sum(tOD(Pgrp,Ngrp))) sum(sum(tOU(Pgrp,Ngrp)))] );
    Mer(iSet) = sum(  sum(sum(tMD(Pgrp,Ngrp))) );
    % Substitutions
    sID(iSet) = sum(sum(tID(Pgrp,Pgrp)));
    sIU(iSet) = sum(sum(tIU(Pgrp,Pgrp)));
    sIF(iSet) = sum(sum(tIF(Pgrp,Pgrp)));
    sOD(iSet) = sum(sum(tOD(Pgrp,Pgrp)));
    sOU(iSet) = sum(sum(tOU(Pgrp,Pgrp)));
    sMD(iSet) = sum(sum(tMD(Pgrp,Pgrp)));
    % Correct
    I = eye(nClasses,nClasses);
    C = sum(tConf() .* I);
    
    pC(iSet) = sum(C(Pgrp));    
    nC(iSet) = sum(C(Ngrp));
    T(iSet) = sum(tT);
    Pos(iSet)= sum(tT(Pgrp));
    Neg(iSet)= sum(tT(Ngrp));
    
    sub(iSet)= sum(sum(tConf(Pgrp,Pgrp))-C(Pgrp));
    predPos(iSet)= sum(sum(tConf(Pgrp,:)));
    predNeg(iSet)= sum(sum(tConf(Ngrp,:)));
    
end


if regexp(chartType,'conf')>0
        
        barlegend= {'Subst.        ';'FN         ';'FP          ';'TN          ';'TP       '};
        barlegendshort = {'S';'FN';'FP';'TN';'TP'};
        errorcolors=[1 0.1 0; 1 0.4 0; 1 0.7 0; 0 0.1 1; 0 0.5 1];
        errorcolors=[1 0.3 0; 1 0.5 0; 1 0.9 0; 1 1 0.8; 1 1 1];
        
        M(:,5)= pC;
        M(:,4)= nC;
        M(:,3)= Neg-nC;
        M(:,2)= predNeg-nC;
        M(:,1) = sub;  
        SEL=0;
        
    elseif regexp(chartType,'full')>0
        
        subst= sID+sIU+sIF+sOD+sOU+sMD;
       
        barlegend= {'Substitution      ';'Deletion      ';'Fragmentation    ';'Insertion    ';'Merge    ';'Underfill    ';'Overfill    ';'TN    ';'TP    '};
        barlegendshort = {'S';'D';'F';'I';'M';'U';'O';'TN';'TP'};
        explode =[1 1 1 1 1 0 0 0 0];        
        errorcolors=[1 0.3 0; 1 0.5 0; 1 0.7 0; 1 0.9 0; 1 1 0 ; 1 1 0.4; 1 1 0.6; 1 1 0.8; 1 1 1];
        
        for i=1:nSets                                
            labels{i} = {...
             ,sprintf('Subst [%2.0f] %2.1f%%  ',subst(i),100*subst(i)/T(i))...
            ,sprintf('D [%2.0f] %2.1f%%  ',Del(i),100*Del(i)/T(i))...
             ,sprintf('F [%2.0f] %2.1f%%  ',Fra(i),100*Fra(i)/T(i))...            
            ,sprintf('I [%2.0f] %2.1f%%  ',Ins(i),100*Ins(i)/T(i))...
            ,sprintf('M [%2.0f] %2.1f%% ',Mer(i),100*Mer(i)/T(i))...
            ,sprintf('U [%2.0f] %2.1f%% ',Und(i),100*Und(i)/T(i))...
            ,sprintf('O [%2.0f] %2.1f%% ',Ove(i),100*Ove(i)/T(i))...
            ,sprintf('TN %2.1f%% ',100*nC(i)/T(i))... 
            ,sprintf('TP %2.1f%% ',100*pC(i)/T(i))...
            };
        end
       
        M(:,9)= pC;
        M(:,8)= nC;
        M(:,7)= Ove;        
        M(:,6)= Und;
        M(:,5)= Mer;
        M(:,4) = Ins;
        M(:,3)= Fra;
        M(:,2) = Del;
        M(:,1)= subst;
        SEL=5;
        
 elseif regexp(chartType,'twoclass')>0
        
        subst= sID+sIU+sIF+sOD+sOU+sMD;
       
        barlegend= {'Deletion      ';'Fragmentation    ';'Insertion    ';'Merge    ';'Underfill    ';'Overfill    ';'TN    ';'TP    '};
        barlegendshort = {'D';'F';'I';'M';'U';'O';'TN';'TP'};
        explode =[1 1 1 1 0 0 0 0];        
        errorcolors=[1 0.5 0; 1 0.7 0; 1 0.9 0; 1 1 0 ; 1 1 0.4; 1 1 0.6; 1 1 0.8; 1 1 1];
        
        for i=1:nSets                                
            labels{i} = {...
            ,sprintf('D [%2.0f] %2.1f%%  ',Del(i),100*Del(i)/T(i))...
             ,sprintf('F [%2.0f] %2.1f%%  ',Fra(i),100*Fra(i)/T(i))...            
            ,sprintf('I [%2.0f] %2.1f%%  ',Ins(i),100*Ins(i)/T(i))...
            ,sprintf('M [%2.0f] %2.1f%% ',Mer(i),100*Mer(i)/T(i))...
            ,sprintf('U [%2.0f] %2.1f%% ',Und(i),100*Und(i)/T(i))...
            ,sprintf('O [%2.0f] %2.1f%% ',Ove(i),100*Ove(i)/T(i))...
            ,sprintf('TN %2.1f%% ',100*nC(i)/T(i))... 
            ,sprintf('TP %2.1f%% ',100*pC(i)/T(i))...
            };
        end
       
        M(:,8)= pC;
        M(:,7)= nC;
        M(:,6)= Ove;        
        M(:,5)= Und;
        M(:,4)= Mer;
        M(:,3) = Ins;
        M(:,2)= Fra;
        M(:,1) = Del;
        SEL=4;
else 
        
        subst= sID+sIU+sIF+sOD+sOU+sMD;
        barlegend= {'Subst.      ';'Del.    ';'Ins.    ';'Underfill    ';'Overfill    ';'TN      ';'TP    '};
        barlegendshort = {'S';'D';'I';'U';'O';'TN';'TP'};
        
        errorcolors=[1 0.3 0; 1 0.5 0; 1 0.9 0; 1 1 0.4; 1 1 0.6; 1 1 0.8; 1 1 1];
        explode =[1 1 1 0 0 0 0];
        
        for i=1:nSets                                
            labels{i} = {...
             ,sprintf('Subst [%2.0f] %2.1f%%  ',subst(i),100*subst(i)/T(i))...
             ,sprintf('D [%2.0f] %2.1f%%  ',Del(i)+Ins(i),100*(Del(i)+Ins(i))/T(i))...             
             ,sprintf('I [%2.0f] %2.1f%%  ',Ins(i)+Mer(i),100*(Ins(i)+Mer(i))/T(i))...             
             ,sprintf('U [%2.0f] %2.1f%% ',Und(i),100*Und(i)/T(i))...
             ,sprintf('O [%2.0f] %2.1f%% ',Ove(i),100*Ove(i)/T(i))...
             ,sprintf('TN %2.1f%% ',100*nC(i)/T(i))... 
             ,sprintf('TP %2.1f%% ',100*pC(i)/T(i))...
            };
        end
                
        M(:,7)= pC;
        M(:,6)= nC;
        M(:,5)= Ove;%+Mer;
        M(:,4)= Und;%+Fra;
        M(:,3) = Ins+Mer;
        M(:,2) = Del+Fra;
        M(:,1)= subst;
        SEL=3;
end



%%%%%%%%%%%%%%%%%% Do the chart plotting
if regexp(chartType,'bar')>0

    handle = figure;
    
    % Figure with error breakdowns.
    bar(M,0.5,'stacked'), colormap(errorcolors);
    legend(barlegend(end:-1:1),-1);
    set(legend,'YDir','reverse');
    xlabel('Method'); ylabel('Time');
    set(gca,'XTickLabel',label);
    
    % Place text with actual percentages at each location
    [nMeth,nErr] = size(M);
    for meth = 1:nMeth
        
        Generality = 100*Pos(meth)/T(meth);
        infoLabel = sprintf( 'NULL: %3.1f%% (%.1f / %.1f) \n', 100-Generality, Neg(meth), T(meth) );
    
        recall = sum(M(meth,end))*100./Pos(meth);
        precision = sum(M(meth,end))*100./predPos(meth);        
        fp = (Neg(meth)-sum(M(meth,end-1)))*100./Neg(meth);
        restxt = sprintf('Precision: %2.1f%% / Recall: %2.1f%%, FP: %2.1f' , precision, recall, fp);
%        restxt = sprintf('Precision: %2.1f%% / Recall: %2.1f%%' , precision, recall);
         
        y=0;
        for err = 1:nErr
            pc = M(meth,err)*100./T(meth);    
            %lablabs = deblank(barlegend{err});
            txt = sprintf('%3.1f%% [%s]', pc, barlegendshort{err} );
            
            mmm = sum(M(meth,:))/100; % 1 percent of full amount
            if M(meth,err) < mmm;
                % cannot leave too small a space for font
                if y==0
                    y = mmm;                
                end
            else
                y = sum( M(meth,1:err) );
            end

            midy = floor(y-(M(meth,err)/2));
            xpos=meth-0.2;
            if pc<4
                % offset x-position for clarity
                xpos = meth+0.3;
            end
            text( xpos, midy, txt );

            % Draw a serious error line if necessary
            if(err==SEL)
                pc = sum( M(meth,1:SEL) )*100./T(meth);
                %txt = sprintf('%3.1f(%3.1f)', pc, sum(M(meth,1:3)) );
                txt = sprintf('SEL: %3.1f%%  ', pc );
                text( meth+0.3, y+100, txt, 'FontWeight','bold' );

                h=line( [meth-0.3,meth+0.3], [y,y] );
                set(h,'LineWidth',2);
            end
        end
        
        text(xpos,T(1)*(1+0.02), restxt);
        text(xpos,T(1)*(1+0.04), infoLabel );    
    end

    title(figureTitle);
    set(gca,'YLim',[0 max(sum(M'))*(1+0.1)]);
    set(gca,'XLim',[0.5 nMeth+0.8]);
    
    
elseif regexp(chartType,'fullpie')>0
    % pie chart
   
    piecolor=errorcolors;%bone;
    handle = figure;
    
    for iSet=1:nSets % Gather all the data
        
        Generality = 100*Pos(iSet)/T(iSet);
        infoLabel = sprintf( 'NULL: %3.1f%% (%.1f / %.1f) \n', 100-Generality, Neg(iSet), T(iSet) );
               
        subplot(nSets, 1, iSet);
        pie(M(iSet,:), explode,labels{iSet}), colormap(piecolor);        
        
        sErrSerious = sum( M(iSet,1:SEL) ) ;
        pc = sum( M(iSet,1:SEL) )*100./T(iSet);
        
        seltxt = sprintf( 'SEL [%2.0f] %2.1f%%', sErrSerious, pc);
        text(-2,1,seltxt);
    
        recall = sum(M(iSet,end))*100./Pos(iSet);
        precision = sum(M(iSet,end))*100./predPos(iSet);        
        fp = (Neg(iSet)-sum(M(iSet,end-1)))*100./Neg(iSet);
        restxt = sprintf('Precision: %2.1f%% / Recall: %2.1f%%, FP: %2.1f' , precision, recall, fp);
%        restxt = sprintf('Precision: %2.1f%% / Recall: %2.1f%%' , precision, recall);
        
        text(0,-1.4, infoLabel);
        text(0,-1.5, restxt);
        %text(-1.5,1.3, label{iSet}); % title
        titletxt = sprintf('[%s]',label{iSet});
        text(-1.5,1.3, titletxt); % title
    end

%    title(figureTitle);

elseif regexp(chartType,'DET')>0 % DET curve % DET curve
        
    
%     pC(iSet)     
%     nC(iSet) 
%     T(iSet) 
%     Pos(iSet)
%     Neg(iSet)
%     
%     sub(iSet)
%     predPos(iSet)
%     predNeg(iSet)
    
%     Del(iSet) 
%     Und(iSet) 
%     Fra(iSet) 
%     Ins(iSet) 
%     Ove(iSet) 
%     Mer(iSet) 
%     % Substitutions
%     sID(iSet) 
%     sIU(iSet) 
%     sIF(iSet) 
%     sOD(iSet) 
%     sOU(iSet) 
%     sMD(iSet) 
   

fprate=(Ins+Ove+Mer)./Neg;
fnrate=(Del+Und+Fra)./Pos;

tprate= pC ./ Pos;
tnrate= nC ./ Neg;
precision= pC ./ predPos;

Irate = Ins./Neg;
Orate = Ove./Neg;
Mrate = Mer./Neg;
Drate = Del./Pos;
Urate = Und./Pos;
Frate = Fra./Pos;

handle{1} = figure;
ylim([0 1]);
xlim([0 1]);
hold on;

plot(fprate, fnrate)

plot(fprate, Drate,'m--o')
plot(fprate, Urate,'c--o')
plot(fprate, Frate,'k--o')

plot(Irate, fnrate,'r-+')
plot(Orate, fnrate,'g-+')
plot(Mrate, fnrate,'b-+')

handle{2} = figure;
hold on;
colormap(errorcolors);
area([Drate;Irate;Frate;Mrate;Urate;Orate;tnrate;tprate]'/2);
hold on; title('Equally weighted NULL vs. Positive');
legend(barlegend(end:-1:1),-1);
set(legend,'YDir','reverse');
%bar(M/675.8359,0.1,'stacked')

handle{3} = figure;
hold on;
colormap(errorcolors); grid on;
ax1=subplot(2,1,1); area(ax1,[Drate;Frate;Urate;zeros(1,length(tprate))]'); view(90,90);
xlabel('threshold');
ylabel('fraction of positive activities');
grid on;
legend({'D' 'F' 'U' 'TP'});
set(legend,'XDir','normal','orientation','horizontal','location','northoutside');

ax2=subplot(2,1,2); area(ax2,[Irate;Mrate;Orate;zeros(1,length(tnrate))]'); view(-90,-90);
set(ax2,'XAxisLocation','top');
%xlabel('threshold');
ylabel('fraction of NULL activities');
grid on;
%legend({'I' 'M' 'O' 'TN'},-1);
legend({' TN' ' O' ' M' ' I'},'XDir','reverse');
set(legend,'location','northoutside','orientation','horizontal');


handle{4} = figure;

ax2=subplot(2,1,1); set(ax2,'position',[.05 .1 .45 .8]);
area(ax2,[Irate;Mrate;Orate;zeros(1,length(tnrate))]'); view(ax2,-90,-90);
set(ax2,'XAxisLocation','bottom','YLim',[0 1]);

xlabel('threshold');
ylabel('fraction of NULL activities');
grid on;

legend({' TN' ' O' ' M' ' I'},'XDir','reverse');
set(legend,'location','northoutside','orientation','horizontal');


colormap(errorcolors); grid on;
ax1=subplot(2,1,2); set(ax1,'position',[.51 .1 .45 .8] );
area(ax1,[Drate;Frate;Urate;zeros(1,length(tprate))]'); view(ax1,90,90);
set(ax1,'XAxisLocation','bottom','XTickLabel',{' '},'YLim',[0 1]);
% xlabel('threshold');
ylabel('fraction of positive activities');
grid on;
legend({'D' 'F' 'U' 'TP'});
set(legend,'XDir','normal','orientation','horizontal','location','northoutside');



elseif regexp(chartType,'twopie')>0 
   
    fprate=(Ins+Ove+Mer)./Neg;
    fnrate=(Del+Und+Fra)./Pos;

    tprate= pC ./ Pos;
    tnrate= nC ./ Neg;
    precision= pC ./ predPos;    
    
    Irate = Ins./Neg;
    Orate = Ove./Neg;
    Mrate = Mer./Neg;
    Drate = Del./Pos;
    Urate = Und./Pos;
    Frate = Fra./Pos;
    Srate = sub./Pos;

   
 i=1;

 labelsFP = {...            
            ,sprintf('I [%2.0f]\n %2.1f%%  ',Ins(i), 100*Irate(i))...
            ,sprintf('M [%2.0f]\n %2.1f%% ',Mer(i), 100*Mrate(i))...           
            ,sprintf('O [%2.0f]\n %2.1f%% ',Ove(i), 100*Orate(i))...
            ,sprintf('TN [%2.0f]\n (specificity) %2.1f%% ',nC(i), 100*tnrate(i))...             
            };
        
labelsFN = {...            
            ,sprintf('D [%2.0f]\n %2.1f%%  ',Del(i), 100*Drate(i))...
            ,sprintf('F [%2.0f]\n %2.1f%%  ',Fra(i), 100*Frate(i))...            
            ,sprintf('U [%2.0f]\n %2.1f%% ',Und(i), 100*Urate(i))...                       
            ,sprintf('TP [%2.0f]\n (recall) %2.1f%% ',pC(i), 100*tprate(i))...
            };


handle = figure;

colormap(errorcolors); %([3 5 9 1],:)
subplot(2,1,1);
pie([Irate(i);Mrate(i);Orate(i);tnrate(i)],labelsFP); 
tottxt = sprintf('Total Negatives, N = %d\n',Neg);
text(-1,-1.5, tottxt);        
restxt = sprintf('False positive rate (fp): %2.2f',fprate);
text(-1,-1.65, restxt);

subplot(2,1,2); 
%figure; colormap(errorcolors);
if sum(sum(Srate))>0    
    labelsFN={sprintf('Subst [%2.0f]\n %2.1f%%  ',subst(i), 100*Srate(i)), labelsFN{:}};
    pie([Srate(i);Drate(i);Frate(i);Urate(i);tprate(i)],labelsFN);
else
    pie([Drate(i);Frate(i);Urate(i);tprate(i)],labelsFN); 
end
tottxt = sprintf('Total Positives, P = %d\n',Pos);
text(-1,-1.5, tottxt);        
restxt = sprintf('Precision: %2.2f',precision);
text(-1,-1.65, restxt);

else
   disp('no chart type selected'); 

end

text(-2.5,1.5, figureTitle);

%allText = findall(handle, 'type', 'text');
%set(allText, 'FontSize', 10);
