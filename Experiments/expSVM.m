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

SETTINGS = setClassifier('SVM', SETTINGS);
SETTINGS.CLASSIFIER_OPTIONS.testing = '-b 1';
GVALUES = 0.01:0.01:0.5;
CVALUES = 1:10;
KERNELVALUES = 1:4;
kernels = {'linear', 'polynomial', 'rbf', 'sigmoid'};

fprintf('\nPreprocessing ');
 [features fType fDescr segments segmentation labelsSegmentation featureLabels SETTINGS]  = prepareFoldData(SETTINGS);
%[features fType fDescr segments segmentation labelsSegmentation] = run_preprocess(dataAll, labelsAll, segmentsAll, SETTINGS);

clear result;
for gValue = GVALUES
    for cValue = CVALUES
        for kernelValue = KERNELVALUES
            fprintf('\nRUNNING EVALUATION FOR SVM with %s kernel, g=%1.2f, c=%i\n', kernels{kernelValue}, gValue, cValue)
            SETTINGS.CLASSIFIER_OPTIONS.training = sprintf('-t %i -g %1.2f -c %i -b 1', kernelValue-1, gValue, cValue);
            tmp = num2str(gValue);
            identifier = sprintf('%s_g_%s_c_%i', kernels{kernelValue}, tmp([1 3:end]), cValue);
            result.(identifier) = [];

            % evaluate
            [confusion, metrics, scoreEval] = run_evaluation(features, fType, fDescr, segments, segmentation, labelsSegmentation, featureLabels, SETTINGS);

            % store results
            result.(identifier).confusion = confusion;
            result.(identifier).metrics = metrics;
            result.(identifier).scoreEval = scoreEval;

            filename = saveExperiment(confusion, metrics, scoreEval, 'SVM', identifier, SETTINGS);  
        end
    end
end

% plot
plotEvaluationResults(result, SETTINGS, 'RPC');