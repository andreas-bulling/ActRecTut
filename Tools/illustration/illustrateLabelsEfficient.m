% Copyright 2011-2014 Ulf Blanke, Swiss Federal Institute of Technology (ETH) Zurich, Switzerland
% Copyright 2011-2014 Andreas Bulling, Max Planck Institute for Informatics, Germany
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

function usedColors =illustrateLabelsEfficient(labels,class,varargin)
% labels(s,1): start
% labels(s,2): stop
% labels(s,3): label
hold all;
if (length(varargin)==1)
    o = varargin{1};
end
if (length(varargin)==3)
    o = varargin{1};
    bMin = varargin{2};
    bMax = varargin{3};
end
%if (length(varargin)==1)
%    o = 0;
%end

%if (length(varargin)>1)
 %   usedColors = varargin{2};
%else
    usedColors = [];
%end

if (class~=0)
    selection = class;
else
    selection = unique(labels(:,3));
end
counter = 1;
for c = selection'
    l = labels(labels(:,3)==c,:);    
    offset(1:size(l,1)) = o;
   
  %  if length(varargin)>1       
    %    col = usedColors(counter,:);
   % else
        col = [rand rand rand];
        usedColors = [usedColors; col];
   % end
    
    line([l(:,1) l(:,2)]',[offset' offset']','color',col, 'LineWidth',8);
    if o<0
        for i=1:size(l,1)
            start = l(i,1);
            stop = l(i,2);
            if ((stop-start)>0)
               r = rectangle('Position',[start, bMin stop-start, abs(bMin)+abs(bMax)],'FaceColor',col);
            else 
                save('/home/blanke/pbs_stderr/BAADthingshappend','start','stop','selection')
            end
        end
    end
    counter = counter +1;
    clear offset;
end
%{ 
classes = unique(labels(:,3));  % add 1 for null class
starts = [];
stops = [];
counter = 1;
for c = classes'
    l = labels(labels(:,3)==c,:);    
    offset(1:size(l,1)) = o;
   
    if length(varargin)>0       
        col = usedColors(counter,:);
    else
        col = [rand rand rand];
        usedColors = [usedColors; col];
    end
    
    line([l(:,1) l(:,2)]',[offset' offset']','color',col);
    if o<0
        for i=1:size(l,1)
            start = l(i,1);
            stop = l(i,2);
            r = rectangle('Position',[start, 0 stop-start, 1],'FaceColor',col);
        end
    end
    counter = counter +1;
    clear offset;
end


%}
