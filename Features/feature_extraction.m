%EXTRACTFEATURES Extracts features on a given stream of data and a
% segmentation
%   INPUT: 
%   - data(N,D), where N is the length of timeseries and D the
%   dimension of raw signal
%   - segmentation(S,[start end]): list with S start and end pairs
%   OUTPUT: features(S,F) F features for S segments.
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

function [ features fType fDescr] = feature_extraction(data, segmentation, varargin)

[featureType verbose] = process_options(varargin, 'featureType', 'VerySimple', 'verbose', 0);

if verbose >= 2
    fprintf('  -> Feature extraction (%s)\n', featureType);
end

if iscell(data)
    features = cell(length(data), 1);
    for d = 1:length(data)
        [features{d} fType fDescr] = feature_extraction(data{d}, segmentation, 'featureType', featureType);
    end
    return;
end

switch featureType
    case 'Raw'
        features = data; % use raw data as features
        fType = ones(1, size(data,2), 1);
        fDescr = {'Raw', 'Raw', 'Raw', 'Raw', 'Raw', 'Raw', 'Raw', 'Raw', 'Raw', 'Raw', 'Raw', 'Raw', 'Raw', 'Raw', 'Raw', 'Raw', 'Raw', 'Raw'};
        return;
    
    case 'VerySimple'
        featureType = @calculateFeaturesVerySimple;
    
    case 'Simple'
        featureType = @calculateFeaturesSimple;

    case 'FFT'
        featureType = @calculateFeaturesFFT;
        
    case 'All'
        featureType = @calculateFeaturesAll;

    otherwise
        error('Unknown feature type');
end

% get description and size to init (speed)
fDescr = featureType();
fDim = length(fDescr) * size(data, 2); 
nSegments=size(segmentation, 1);
features(1:nSegments, 1:fDim) = 0;
tmp = repmat(1:length(fDescr), size(data, 2), 1);
fType = reshape(tmp, 1, []);

for s = 1:nSegments
    start = segmentation(s, 1);
    stop = segmentation(s, 2);

    f = featureType(data(start:stop, :));
    features(s, :) = f;    
end

