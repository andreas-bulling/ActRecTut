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

%clear; % it's saver
evalType = {'pd', 'pi'};
mfilename
for ec =  evalType
    for s =  [1 2]
        e = ec{:}; % cell aufloesen
        fprintf('\nRUNNING EVALUATION FOR %s ', e)
        settings;
        SETTINGS = setClassifier('knnVoting', SETTINGS);
        SETTINGS.SENSORS_USED = {'acc_1'};
        SETTINGS.SUBJECT = s;
        SETTINGS.EVALUATION = e;
        % preprocess
        [features fType fDescr segments segmentation labelsSegmentation featureLabels SETTINGS] = prepareFoldData(SETTINGS);

        % evaluate
        [confusion, metrics, scoreEval] = run_evaluation(features, fType, fDescr, segments, segmentation, labelsSegmentation, featureLabels, SETTINGS);

        % store results
        filename = saveExperiment(confusion, metrics, scoreEval, mfilename, e, SETTINGS);   
    end
end