%% function [setidx,param,kc] = jointboosting_train(features, NweakClassifiers, Nclasses, selectedFeatures)
%   Trains a jointboosting-model
% INPUT
% features(1,:):    annotation of feature
% features(2,:):    start of segment
% features(3,:):    end of segment
% features(i>3,:)   features of segment/sample
% NweakClassifiers: number of weak classifiers used
% Nclasses:         number of classes present in the dataset
% selectedFeatures: The indices of used features (e.g., if you want to use
%                   a subset of features, it should be i>3.
% TODO: Wenn Vector komplett 0 ist, gehts schief
% Null class: has to be label 0.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright 2009 Christian Wojek (jointboosting), Technical University of Darmstadt, Germany
% Copyright 2009 Nikodem Majer (matlab interface), Technical University of Darmstadt, Germany
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

function [setidx, param, kc, sigA, sigB] = jointboostingtrain(labels, features, NweakClassifiers )
occClasses = unique(labels);
nLabels = length(occClasses);
%assert(min(occClasses)==0,'Class labels do not start with 0');
labels = labels-1; % Null class: has to be label 0 here
 'c++'
[setidx,param,kc, sigA, sigB] = mexjointboosting(nLabels, labels, features, NweakClassifiers, 0);
    
 