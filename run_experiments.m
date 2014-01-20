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

% Load default settings
settings

if ~exist('id', 'var')
    id = 1;
end
fprintf('Processing Experiment %d\n', id); pause(1);
global counter;
fprintf('counter=&d',counter);
if selectjob(id)
    fprintf('doing experiment %d', id);
    % Load default settings
    settings
    expTutorial;
    %expStudy_1chain;
end

if selectjob(id)
    fprintf('doing experiment %d', id);
    % Load default settings
    settings    
    expStudy_4chain;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% DO NOT PROCESS OTHER EXPERIMENTS %%%%%%%%%%
fprintf('exiting');
return; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1. Stump: To quickly run an experiment
if selectjob(id)
    % Load default settings
    settings
    expDebug
end

%% 2. comparing different classifiers (VerySimpleFeatures)
if selectjob(id)
    % Load default settings
    settings
    expClassifiers
end

%% 3. comparing different rounds for jointBoosting
if selectjob(id)
    % Load default settings
    settings
    expJointBoosting_Rounds
end

%% 4. comparing different values for parameter k for kNN
if selectjob(id)
    % Load default settings
    settings
    expKnn_k
end

%% 5. comparing different values for distribution for NaiveBayes (normal, kernel)
if selectjob(id)
    % Load default settings
    settings
    expNaiveBayes
end

%% 6. comparing different SVM parameters (c, g, kernel)
if 0
    % Load default settings
    settings
    expSVM
end

%% 7. comparing different HMM parameters (nStates, nGaussians)
if selectjob(id)
    % Load default settings
    settings
    expHMM
end

%% 8. comparing different window sizes for kNN (verySimpleFeatures)
if selectjob(id)
    % Load default settings
    settings
    expWindowSizes
end

%% 9. comparing different sensor types (ACC vs. GYR)
if selectjob(id)
    % Load default settings
    settings
    expSensorTypes
end

%% 10. comparing different sensor placements (hand, lower arm, upper arm)
if selectjob(id)
    % Load default settings
    settings
    expSensorPlacements
end

%% 11. comparing different fusion strategies (early, early+feature selection, late)
if selectjob(id)
    % Load default settings
    settings
    expFusion
end

%% 12. comparing different feature sets (Raw, VerySimple, Simple, FFT, All)
if selectjob(id)
    % Load default settings
    settings
    expFeatures
end

%% 13. comparing different number of top features (from feature selection)
if selectjob(id)
    % Load default settings
    settings
    expTopFeatures
end

%% 14. comparing different evaluation methods (time, score)
if selectjob(id)
    % Load default settings
    settings
    expEvalMethods
end

%% 15. comparing different evaluation schemes (pd, pi, loio)
if selectjob(id)
    % Load default settings
    settings
    expEvalSchemes
end