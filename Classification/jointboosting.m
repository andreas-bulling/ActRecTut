%% function [posteriors posteriors_soft] = jointboosting_test(features, Nclasses, selectedFeatures, setidx, param, kc)
%   classifies a feature vector
% INPUT
% features(1,:):    annotation of feature, should be 0, or groundtruth (be careful not to use it  by accident :)
% features(2,:):    start of segment
% features(3,:):    end of segment
% features(i>3,:)   features of segment/sample
% Nclasses:         number of classes present in the dataset
% selectedFeatures: The indices of used features (e.g., if you want to use
%                   a subset of features, it should be i>3.
% setidx, param, kc:parameters of Jointboosting Model
% OUTPUT
% posteriors(f,1): annotation/groundtruth
% posteriors(f,2): start of segment
% posteriors(f,3): stop of segment
% posteriors(f,4) = class with highest probabiliy
% posteriors(f,4:4+NClasses) = classification results
% posteriors_soft: same as posteriors, but normalised by soft_max.
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

function [posteriors posteriors_soft] = jointboosting(model,features, varargin)

%nClasses = floor(log2(max(double(model.setidx))))+1; 
%warning('check if this makes sense');
nClasses=length(model.sigA);
nSamples = size(features,1);
posteriors(nSamples,1:nClasses)=0;
posteriors_soft(nSamples,1:nClasses)=0;
posteriors_soft2(nSamples,1:nClasses)=0;
for f = 1:nSamples % feature per segment
    posteriors(f,:) = jbclassify(nClasses, model.setidx, model.param, model.kc, features(f,:)');
    posteriors_soft(f,:) = softmax(posteriors(f,:)')';
    posteriors_soft2(f,2:end) = softmax(posteriors(f,2:end)')';
    posteriors_soft2(f,1) = 0.5;
end
posteriors = posteriors_soft2;
disp('' );
% debugging: put some information about the datastream to the classification
%{ 
[v classes ]= max(posteriors'); % rowwise maximum gives winning class
classes = classes';
classes = classes-1;
%}

