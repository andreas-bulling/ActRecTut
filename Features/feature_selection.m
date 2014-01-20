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
function [result featureSelectionTime] = feature_selection(data, labels, varargin)

    [method options verbose] = process_options(varargin, 'method', 'none', 'options', 10, 'verbose', 0);

    if verbose >= 2
        fprintf('  -> Feature Selection (%s)\n', method);
    end
    
    tic;

    if iscell(data)
        result = cell(length(data),1);
        for d = 1:length(data)
           result{d} = feature_selection(data{d}, labels, 'method', method, 'options', options);
        end
        
        featureSelectionTime = 0;
        return;
    end

    switch method
        case 'mRMR'
            result = mrmr_mid_d(data, labels, options);
            %[result score] = mrmr_mid_d_modified(data, labels, options);

        case 'SFS'
            maxdev = chi2inv(.95, 1);
            opt = statset('display', 'iter',...
                          'TolFun', maxdev,...
                          'TolTypeFun', 'abs');

            result = sequentialfs(@critfun, data, labels, ...
                                   'cv', 'none', ...
                                   'nullmodel', true, ...
                                   'options', opt, ...
                                   'direction', 'forward', ...
                                   'nfeatures', options);
                               
       case 'SBS'
            maxdev = chi2inv(.95, 1);
            opt = statset('display', 'iter',...
                          'TolFun', maxdev,...
                          'TolTypeFun', 'abs');

            result = sequentialfs(@critfun, data, labels, ...
                                   'cv', 'none', ...
                                   'nullmodel', true, ...
                                   'options', opt, ...
                                   'direction', 'backward', ...
                                   'nfeatures', options);

        case 'none'
            result = 1:size(data, 2);

        otherwise
             error('Feature selection method unknown');
    end
    
    featureSelectionTime = toc;
end

% TODO: use better criterion function
function dev = critfun(X, Y)
    [~, dev] = glmfit(X, Y, 'normal'); 
end