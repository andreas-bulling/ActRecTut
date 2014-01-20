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

% illustrateBoostingSelection
settings;
classNames=SETTINGS.CLASSLABELS(2:12); % remove NULL class as not trained 
classNames=classNames(sort(1:11,'descend')); % and turn 
nClasses=SETTINGS.CLASSES;
selectedFeatures = featureLabels(model.model.param(:,3)+1);

nRounds=size(model.model.setidx,1);
sharing(1:nRounds,1:nClasses) = 0;
%model.model.setidx
bits = dec2bin(model.model.setidx);
for r=1:nRounds   
    for i=1:size(bits,2)
        if str2num(bits(r,i))==1
            sharing(r,i) = 1;
        end
    end
end
limit= 20;
imagesc(sharing(1:limit,1:11));
set(gca,'YTick',1:limit);
set(gca,'XTick',1:nClasses);
set(gca,'YTickLabels',selectedFeatures(1:limit));
set(gca,'XTickLabels',classNames);

colormap('gray');