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

function fResult = saveExperiment(confusion, metrics, scoreEval, experiment, param, SETTINGS, varargin)
[fSelection featureLabels] = process_options(varargin, 'fSelection', [],'featureLabels', []);

SETTINGS.PATH_OUTPUT_RESULT = [SETTINGS.PATH_OUTPUT '/experiments/' experiment];

if ~exist(SETTINGS.PATH_OUTPUT_RESULT, 'dir')
    mkdir(SETTINGS.PATH_OUTPUT_RESULT);
end

if isinteger(param)
    param = sprintf('%d', param);
end

if isfloat(param)
    param = sprintf('%f', param);
end

if (strcmp(SETTINGS.EVALUATION,'pd')==1)
    fResult = sprintf('%s/%s_subject%i_%s.mat', SETTINGS.PATH_OUTPUT_RESULT, param, SETTINGS.SUBJECT, SETTINGS.DATASET);
else
    fResult = sprintf('%s/%s_%s.mat', SETTINGS.PATH_OUTPUT_RESULT, param, SETTINGS.DATASET);
end

if SETTINGS.VERBOSE_LEVEL >= 2
    disp(['Saving experiment in ' fResult]);
end

save(fResult, 'confusion', 'metrics', 'scoreEval', 'SETTINGS', 'fSelection', 'featureLabels');