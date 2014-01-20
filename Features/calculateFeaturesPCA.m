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

function features = calculateFeaturesPCA( varargin )

if isempty(varargin)
    features = {'PCA'};
else
    data = varargin{1};
    
    [pn, ps1] = mapstd(data);
    [features, ps2] = processpca(pn, 0.02);

    [coefs, scores, variances, t2] = princomp(data);
    varcontrib = cumsum(variances)./sum(variances) * 100;
    ndim = find(varcontrib==100, 1 );
    n = size(data, 1);
    reconstructed = repmat(mean(data, 1), n, 1) + scores(:, 1:ndim) * coefs(:, 1:ndim)';
    [vals indices] = max(scores);
    
    %plot(scores(:, 1), scores(:, 2),'+')
    %xlabel('1st Principal Component')
    %ylabel('2nd Principal Component')
    %gname

    %percent_explained = 100*variances/sum(variances);
    %pareto(percent_explained)
    %xlabel('Principal Component')
    %ylabel('Variance Explained (%)')

    %biplot(coefs(:, 1:2), 'scores',scores(:, 1:2));
    
    %[st2, index] = sort(t2, 'descend'); % Sort in descending order.
    %extreme = index(1)
end