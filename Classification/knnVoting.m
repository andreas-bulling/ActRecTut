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

function scores = knnVoting(model, data, varargin)

options = varargin{1};
[k] = process_options(options.testing, 'k', 5);

[IDX, distances] = knnsearch(model.traindata, data, 'k', k);
nLabels = length(unique(model.labels'));
scores(1:length(IDX), 1:nLabels) = 0; % init to speed up
for point = 1:size(IDX, 1)
    kn_labels = model.labels(IDX(point, :));
    
    for iLabel = unique(kn_labels)'
        scores(point, iLabel) = size(find(kn_labels==iLabel), 1) / k;
    end
end