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

% files in output special
figure;
subplot(1,2,1);
plot(adaption(:,1));hold all;
plot(traindata(sort(1:13, 'descend'),1))
title('precision');
legend('Personalized person-indpendent model','Person-specific only');
ylim([0 1]);
set(gca,'XTick',1:13);
set(gca,'XTickLabels',[0:10 15 25]);
subplot(1,2,2);

plot(adaption(:,2));hold all;
plot(traindata(sort(1:13, 'descend'),2))
legend('Personalized person-indpendent model','Person-specific only');
title('recall');
set(gca,'XTick',1:13);
set(gca,'XTickLabels',[0:10 15 25]);
ylim([0 1]);