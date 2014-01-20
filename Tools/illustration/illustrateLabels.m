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

function col =illustrateLabels(labels,varargin)
% labels(s,1): start
% labels(s,2): stop
% labels(s,3): label
if (length(varargin)>0)
    pos = varargin{1};
else
    pos = 0;
end
classes = unique(labels(:,3));  % add 1 for null class
%myPlotData = [];
%myPlotData(1:max(labels(:,2)),1:length(classes)+1)= -inf;% add 1 for null class
  
for i = 1:size(labels,1)
    if (labels(i,3)==0)
        continue;
    end
    start = labels(i,1);
    stop = labels(i,2);
    c = labels(i,3)+1; % leave 1 for null class (not annotated)
    if (stop<start)
        error('stop<start');
    end
 %   myPlotData(start:stop,c) = pos;
   % line([start start],[pos-0.3 pos+0.3],'Color',[0.6 0.6 0.6]);
   % line([stop stop],[pos-0.3 pos+0.3],'Color',[0.6 0.6 0.6]);
   r = rectangle('Position',[start, 0 stop-start,1],'FaceColor',[0.7 0.7 0.7],'LineWidth',3);
end
%myPlotData(myPlotData==0) = -inf;
%a = plot(1:max(labels(:,2)), myPlotData,'x');
col = get(r(length(r)),'FaceColor');


