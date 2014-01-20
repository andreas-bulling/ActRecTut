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

function [training test] = standardizeData(trainingData, testData, varargin)

[verbose] = process_options(varargin, 'verbose', 0);

if verbose >= 2
    disp('  -> Standardization');
end

if iscell(trainingData) && iscell(testData)
    assert(length(trainingData)==length(testData));
    training = cell(length(trainingData),1);
    test = cell(length(testData),1);
    for t=1:length(trainingData)
        [training{t} test{t}] = standardizeData(trainingData{t}, testData{t});
    end
else
    mu = mean(trainingData);        % only on trainData, more fair
    stdeviation = std([trainingData]);
    training = standardize2(trainingData', mu', stdeviation')';
    test = standardize2(testData', mu', stdeviation')';
end