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

SETTINGS = setClassifier('knnVoting', SETTINGS);
SETTINGS.FEATURE_TYPE = 'VerySimple';
SETTINGS.FEATURE_SELECTION = 'none';
strategies = {'early', 'earlyfs', 'late'};

clear result;
for iStrategy = strategies
    fprintf('\nRUNNING EVALUATION FOR %s decision fusion ', iStrategy{:})
    
    switch iStrategy{:}
        case 'earlyfs'
            SETTINGS.FEATURE_SELECTION = 'mRMR';
            SETTINGS.FEATURE_SELECTION_OPTIONS = 10;
            SETTINGS.FUSION_TYPE = 'early';
            
        otherwise
            SETTINGS.FEATURE_SELECTION = 'none';
            SETTINGS.FUSION_TYPE = iStrategy{:};
    end
    result.(iStrategy{:}) = [];

    % preprocess
 [features fType fDescr segments segmentation labelsSegmentation featureLabels SETTINGS] = prepareFoldData(SETTINGS);
    %[features fType fDescr segments segmentation labelsSegmentation] = run_preprocess(dataAll, labelsAll, segmentsAll, SETTINGS);

    % evaluate
    [confusion, metrics, scoreEval] = run_evaluation(features, fType, fDescr, segments, segmentation, labelsSegmentation, featureLabels, SETTINGS);

    % store results
    result.(iStrategy{:}).confusion = confusion;
    result.(iStrategy{:}).metrics = metrics;
    result.(iStrategy{:}).scoreEval = scoreEval;  

    filename = saveExperiment(confusion, metrics, scoreEval, 'fusion',  iStrategy{:}, SETTINGS); 
end