%SEGMENT Continuous data is segmented into pieces
%   Segmentation can be instantiated by several techniques
%   This example deals with the simplest case using a sliding window
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

function segments = segment(data, varargin )

[method options samplingRate wSizeSecond sSizeSecond eThreshold verbose] = process_options(...
    varargin, 'method', 'SlidingWindow', 'options', [], 'samplingrate', 32, 'windowsize', 0.5, 'stepsize', 0.1, 'energythreshold', 2, 'verbose', 0);

wSize = secondsToSamples(wSizeSecond, samplingRate);
sSize = secondsToSamples(sSizeSecond, samplingRate);

if verbose >= 2
    fprintf('  -> Segmentation (%s)\n', method);
end

if ~iscell(data)
    data = {data};
end
    
for iDataCell = data
    switch method
        case 'SlidingWindow'
            segments = segmentSlidingWindow(iDataCell{:}, wSize, sSize);

        case 'Energy'
            segments = segmentEnergy(iDataCell{:}, eThreshold);

        case 'Rest'
            segments = segmentRest(iDataCell{:}, options);
            
        case 'none'
            segments = segmentNone(iDataCell{:});
    end
end
