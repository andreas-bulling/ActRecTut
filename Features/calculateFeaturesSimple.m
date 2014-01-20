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

function features = calculateFeaturesSimple( varargin )

if (isempty(varargin))
    features = {'Mean', 'Variance', 'ZCR', 'MCR'};
else
    data = varargin{1};
    f1 = mean(data);
    f2 = var(data);
    
    f3 = [];
    signdata = sign(data);
    for index = 1:size(data,2)
        f3 = [f3 sum(signdata(:,index) .* [signdata(2:end,index); signdata(end,index)] == -1)];
    end
    
    f4 = [];
    for index = 1:size(data,2)  
        signdata = sign(data(:,index) - mean(data(:,index)));
        f4 = [f4 sum(signdata .* [signdata(2:end); signdata(end)] == -1)];
    end
    
    features = [f1 f2 f3 f4];
end

