%PLOTMAT Display a matrix.
%
%	Description
%	PLOTMAT(MATRIX, TEXTCOLOUR, GRIDCOLOUR, FONTSIZE) displays the matrix
%	MATRIX on the current figure.  The TEXTCOLOUR and GRIDCOLOUR
%	arguments control the colours of the numbers and grid labels
%	respectively and should follow the usual Matlab specification. The
%	parameter FONTSIZE should be an integer.
%
%
%  inargs: 
%  matrix : nxn matrix
%  labels : cell array[n] of labels
%
% optional:
%   textcolour
%   gridcolour: e.g. [0.1 0.1 0.1]
%   fontsize: e.g. [1 1 1]
%
% Copyright 2011-2014 Ulf Blanke, Swiss Federal Institute of Technology (ETH) Zurich, Switzerland
% Copyright 2011-2014 Andreas Bulling, Max Planck Institute for Informatics, Germany
% Copyright 1996-2001 Ian T Nabney
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

function plotmatAll(matrix,labels, caption, textcolour, gridcolour, fontsize)

set(gcf,'Position',[183 102 924 292]);

if nargin == 3
     textcolour =[0 0 0];
     gridcolour =[.9 .9 .9];
     fontsize=12;     
end
%% put values
[m,n]=size(matrix);


for rowCnt=1:m,
   rec =  matrix(rowCnt,:)/norm(matrix(rowCnt,:));
  for colCnt=1:n,line
     err =  1-matrix(:,colCnt)/sum(matrix(:,colCnt));
    if (rowCnt==colCnt)
      FontWeight='bold';
    else
      FontWeight='normal';
    end
    if (matrix(rowCnt,colCnt)==0)
        continue;
    end        
	numberString=sprintf('%.0f',(matrix(rowCnt,colCnt)));

   if rowCnt==colCnt
       color=[err(rowCnt) 1 err(rowCnt)]
   else
       color=[ 1 err(rowCnt) err(rowCnt)];
   end
    rectangle('Position',[1+colCnt, m-rowCnt+1, 1, 1],'FaceColor',...
        color,'EdgeColor',[1 1 1]);

	text(1+1+colCnt-.5,1+m-rowCnt+.5,numberString, ...
	  'HorizontalAlignment','center', ...
	  'Color', textcolour, ...
	  'FontWeight',FontWeight, ...
	  'FontSize', 10);
  end;
end;

%% put recall
%recall = normalise(matrix,2);
%recall = diag(recall);
recall = diag(spdiags(sum(abs(matrix),2),0,rowCnt,rowCnt)\matrix);

   text(2-.1,.5,'precision', ...
	  'HorizontalAlignment','right', ...
	  'Color', [0.204 0.302 0.49], ...
        'FontAngle','italic', ...
	  'FontWeight',FontWeight, ...
	  'FontSize', 12);  
  
  text(1+2+m-.5,1+m+.5,'recall', ...
	  'HorizontalAlignment','center', ...
	  'Color', [0.204 0.302 0.49], ...
      'FontAngle','italic', ...
	  'FontWeight',FontWeight, ...
      'FontSize', 12);  
      %'Rotation',45, ...
	  


%% put precision
%precision = normalise(matrix,1);
%precision = diag(precision);
precision = diag(spdiags(sum(abs(matrix'),2),0,rowCnt,rowCnt)\matrix');


for c=1:m
    
    str = sprintf('%2.2f',recall(m-c+1)*100);
   text(1+2+m-.5,c+.5,str, ...
	  'HorizontalAlignment','center', ...
	  'Color', textcolour, ...
	  'FontWeight',FontWeight, ...
	  'FontSize', fontsize);  
  
  str = sprintf('%2.2f',precision(m-c+1)*100);
  text(1+2+(m-c)-.5,.5,str, ...
	  'HorizontalAlignment','center', ...
	  'Color', textcolour, ...
	  'FontWeight',FontWeight, ...
	  'FontSize', fontsize);  
  
end



%% put labels
for c=1:m
   text(1+1-.1,c+.5,labels{m-c+1}, ...
	  'HorizontalAlignment','right', ...
	  'Color', textcolour, ...
	  'FontWeight',FontWeight, ...
	  'FontSize', 12,...
      'Interpreter','none');  
  
  text(1+2+(m-c)-.5,1+m+.5,labels{m-c+1}, ...
	  'HorizontalAlignment','left', ...
	  'Color', textcolour, ...
	  'FontWeight',FontWeight, ...
      'Rotation',45, ...
	  'FontSize', 12,...
      'Interpreter','none');  
  
end

set(gca,'Box','on', ...
  'Visible','on', ...
  'xLim',[0 n+1+1+1], ...
  'xGrid','on', ...
  'xTickLabel',[], ...
  'xTick',[0 2:n+1+1+1], ...
  'yGrid','on', ...
  'yLim',[0 m+1+1], ...
  'yTickLabel',[], ...
  'yTick',0:m+1+1, ...
    'GridLineStyle',':', ...
  'LineWidth',3, ...
  'XColor',gridcolour, ...
  'YColor',gridcolour);
xlabel(caption,'Color',[0 0 0],'FontWeight','bold','FontSize', 12, 'Interpreter', 'none');
ylabel('groundtruth','Color',[0 0 0],'FontSize', 12,'FontWeight','bold');
title('classification','Color',[0 0 0],'FontSize', 12,'FontWeight','bold');
