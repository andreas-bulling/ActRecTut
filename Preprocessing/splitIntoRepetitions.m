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

function [data labels segments nRepetitions] = splitIntoRepetitions(dataAll, labelsAll, segmentsAll)

labels = cell(0);
data = cell(0);
segments = cell(0);

startIndices = segmentsAll(find(segmentsAll(:, 4) == max(labelsAll))+1, 1);
startIndices = [1; startIndices(1:end-1)];
stopIndices = segmentsAll(find(segmentsAll(:, 4) == max(labelsAll)), 2);
nRepetitions = size(startIndices, 1);

for iRepetition = 1:nRepetitions
    data{iRepetition, 1} = dataAll(startIndices(iRepetition):stopIndices(iRepetition), :);
    labels{iRepetition, 1} = labelsAll(startIndices(iRepetition):stopIndices(iRepetition));
    segments{iRepetition, 1} = labeling2segments(labels{iRepetition}, 0);
end