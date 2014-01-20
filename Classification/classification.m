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

function [scores testTime] = classification(model, data, varargin)

[method selectedFeatures options verbose] = process_options(varargin, 'method', 'knnVoting', 'selectedfeatures', [], 'options', [], 'verbose', 0);

if verbose >= 2
    fprintf('  -> Classification (%s)\n', method);
end

tic;

% keep this file to wrap into ARC 
if iscell(model)
    assert(iscell(data)); % support same method type on its own data
    scores = cell(length(model), 1);
    
    for c = 1:length(model)
        d = data{c}(:, selectedFeatures{c});
        scores{c} = model{c}.posterior(model{c}.model, d, options);
    end   
else
    d = data(:, selectedFeatures);
    scores = model.posterior(model.model, d, options);
end

testTime = toc;