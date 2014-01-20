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

SETTINGS = setClassifier('cHMM', SETTINGS);
NSTATES = 1:5;
NGAUSS = 1;

fprintf('\nPreprocessing ');
 [features fType fDescr segments segmentation labelsSegmentation featureLabels SETTINGS]  = prepareFoldData(SETTINGS);
%[features fType fDescr segments segmentation labelsSegmentation] = run_preprocess(dataAll, labelsAll, segmentsAll, SETTINGS);

clear result;
for nStates = NSTATES
    for nGauss = NGAUSS
        fprintf('\nRUNNING EVALUATION FOR HMM, nStates=%i, nGauss=%i\n', nStates, nGauss)
        % strong left right model
        t = eye(nStates) * 0.9 + triu(0.1 * ones(nStates, nStates), 1) - triu(0.1*ones(nStates, nStates), 2);
        t(nStates,nStates)=1; % stop in last state.
        % skip state left right model model
        % t = eye(NSTATES)*0.9+triu(0.1*ones(NSTATES,NSTATES),1) -triu(0.1*ones(NSTATES,NSTATES),NSTATES-1)
        SETTINGS.CLASSIFIER_OPTIONS.training = {'mIter', 10, 'nStates', nStates, 'nGauss', nGauss, ...
            'mixmat', [], 'trans', t, 'prior', [1 zeros(1, nStates-1)]}; % TODO        
        SETTINGS.CLASSIFIER_OPTIONS.testing = {'wSize', 40, 'wStep', 10}; % observation length
        identifier = sprintf('states_%i_gaussians_%i', nStates, nGauss);
        result.(identifier) = [];

        % evaluate
        [confusion, metrics, scoreEval] = run_evaluation(features, fType, fDescr, segments, segmentation, labelsSegmentation, featureLabels, SETTINGS);

        % store results
        result.(identifier).confusion = confusion;
        result.(identifier).metrics = metrics;
        result.(identifier).scoreEval = scoreEval;

        filename = saveExperiment(confusion, metrics, scoreEval, 'HMM', identifier, SETTINGS);  
    end
end

% plot
plotEvaluationResults(result, SETTINGS, 'RPC');