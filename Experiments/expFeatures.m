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

feature_sets = {'Raw', 'VerySimple', 'Simple', 'FFT', 'All'};

clear result;
for iFeatureset = feature_sets
    fprintf('\nRUNNING EVALUATION FOR feature set %s ', iFeatureset{:})
    SETTINGS.FEATURE_TYPE = iFeatureset{:};
    result.(iFeatureset{:}) = [];
    
    if strcmp(iFeatureset{:}, 'Raw')
        SETTINGS.SEGMENTATION_TECHNIQUE = 'none';
    end

    % preprocess
 [features fType fDescr segments segmentation labelsSegmentation featureLabels SETTINGS] = prepareFoldData(SETTINGS);
    %[features fType fDescr segments segmentation labelsSegmentation] = run_preprocess(dataAll, labelsAll, segmentsAll, SETTINGS);

    % evaluate
    [confusion, metrics, scoreEval] = run_evaluation(features, fType, fDescr, segments, segmentation, labelsSegmentation, featureLabels, SETTINGS);

    % store results
    result.(iFeatureset{:}).confusion = confusion;
    result.(iFeatureset{:}).metrics = metrics;
    result.(iFeatureset{:}).scoreEval = scoreEval;
    
    filename = saveExperiment(confusion, metrics, scoreEval, 'feature',  iFeatureset{:}, SETTINGS);
end