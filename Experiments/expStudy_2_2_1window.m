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

clear; % it's saver
evalType = {'pd','pi'};

WINDOWSIZES = [0.1 0.25 0.5 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0];

for iWS = 1:length(WINDOWSIZES)
    fprintf('\nRUNNING EVALUATION FOR window size %1.2f\n', WINDOWSIZES(iWS))   
    for ec =  evalType
        for s =  [1 2]
            e = ec{:}; % cell aufloesen
            fprintf('\nRUNNING EVALUATION FOR %s ', e)
            settings;
            SETTINGS.SENSORS_USED = {'acc_1'};
            SETTINGS = setClassifier('knnVoting', SETTINGS);
            SETTINGS.W_SIZE_SECOND = WINDOWSIZES(iWS);
            SETTINGS.W_STEP_SECOND = 0.05; % fixed
            SETTINGS.SUBJECT = s;   
            SETTINGS.EVALUATION = e;
            % preprocess
            [features fType fDescr segments segmentation labelsSegmentation featureLabels SETTINGS] = prepareFoldData(SETTINGS);

            % evaluate
            [confusion, metrics, scoreEval] = run_evaluation(features, fType, fDescr, segments, segmentation, labelsSegmentation, featureLabels, SETTINGS);

            % store results
            filename = saveExperiment(confusion, metrics, scoreEval, mfilename, [e num2str(WINDOWSIZES(iWS))], SETTINGS);   
        end
    end
end