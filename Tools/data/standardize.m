function [S, mu, sigma2] = standardize(M, mu, sigma2)
% function S = standardize(M, mu, sigma2)
% Make each column of M be zero mean, std 1.
% Thus each row is scaled separately.
%
% If mu, sigma2 are omitted, they are computed from M
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

if nargin < 2
  mu = mean(M,2);
  sigma2 = std(M,0,2);
  sigma2 = sigma2 + eps*(sigma2==0);
end

[nrows ncols] = size(M);
S = M - repmat(mu(:), [1 ncols]);
S = S ./ repmat(sigma2, [1 ncols]);

%if( sum(sum(isnan(S))) > 0 )
%    warning('standardize:Warning', '%s values are NaN after standardization', num2str(sum(sum(isnan(S)))));
%end
