%CALCULATELABELSTATISTICS calculates statistics on labels
%   Often it is useful to get an idea of the data in terms of statistics
%   for later parameter choice
%   e.g. mean/var duration, occurrence, distribution
%
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

function [ stats ] = calculateLabelStatistics(labels)

C = unique(labels(:,4))';
stats(C,1:3) = 0;
for c = C
    instances = labels(labels(:,4)==c,:);
    stats(c,1) = size(instances,1);
    stats(c,2) = mean(instances(:,3));
    stats(c,3) = std(instances(:,3));   
    stats(c,4) = sum(instances(:,3));   
end

