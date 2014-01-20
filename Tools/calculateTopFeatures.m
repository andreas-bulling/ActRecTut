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

function [result medval] = calculateTopFeatures(matrix, varargin)

[ nTopFeatures ] = process_options( varargin, 'nTopFeatures', 100);

if( ~exist('matrix', 'var') )
    error('plotFeatureRanking:BadParameter', 'Please provide a rank matrix.');
end

nFeatures = size(matrix, 1);
medval = zeros(1, nFeatures);

for iF = 1:nFeatures
    ranks = matrix(iF, :);    
    % It is important not to count rank 0 in the median calculation
    iValid = find(ranks>0);
    if ~isempty(iValid>0)        
        usedRanks = ranks(iValid);
        medval(iF) = median( usedRanks );
    end
end

iValid = find( medval>0 );
[~, iTopValid] = sort(medval(iValid));
iTop = iValid(iTopValid);

result = iTop(1:nTopFeatures);