% Fuses scores from multiple classifiers into a single score.
% Method: Mean score
% if scores is cell, multiple classifiers are assumed.
% if scores is array, a single classifier is active and fusion is not
% needed
% scores{I}(s,c), scores from I classifiers for segment s and classes c.
% outputs
% scoresOut(s,c): (not renormalized) fused score for each segment and class.
% confidence(s): confidence of fusion, e.g. variance, entropy of classifer scores for
% a segment
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

function [scoresOut confidence] = fusion(scores, varargin)

[verbose] = process_options(varargin, 'verbose', 0);

if verbose >= 2
    fprintf('  -> Fusion\n');
end

if ~iscell(scores)
    scoresOut = scores;
    confidence(1:size(scores, 1), 1) = 1;
    
    if verbose >= 3
        fprintf('Nothing to fuse');
    end
    return;
end
    nClassifiers =length(scores);
    [nSegments nClasses] = size(scores{end});
    
    % mean
    scoresOut(1:nSegments, 1:nClasses) = 0;    
    for i = 1:nClassifiers
      scoresOut = scoresOut + scores{i};
    end
    scoresOut = scoresOut/nClassifiers;
    
    % TODO: efficient method for calculating confidence
    confidence(1:nSegments, 1) = 1;
end