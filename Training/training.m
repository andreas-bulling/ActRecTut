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

function [classifier trainingTime] = training(trainData, trainLabels, varargin)

[method selectedFeatures options classLabels verbose] = process_options(varargin, 'method', 'knnVoting', 'selectedfeatures', [], 'options', [], 'classlabels', {}, 'verbose', 0);

if verbose >= 2
    fprintf('  -> Training (%s)\n', method);
end

tic;

if iscell(trainData)
    classifier = cell(length(trainData), 1);
    
    for t = 1:length(trainData)
         classifier{t} = training(trainData{t}, trainLabels, 'method', method, 'selectedfeatures', selectedFeatures{t}, 'options', options, 'classlabels', classLabels, 'verbose', verbose);
    end
else
    trainData = trainData(:, selectedFeatures);
    
    switch method
        case 'NaiveBayes'           
            classifier.model = NaiveBayes.fit(trainData, trainLabels, options.training{:}); % GMM
            classifier.posterior = @naiveBayes;

        case 'knnVoting'
            classifier.model.traindata = trainData;
            classifier.model.labels = trainLabels;
            classifier.posterior = @knnVoting;

        case 'SVM'
            classifier.model = svmtrain(trainLabels, trainData, options.training);
            classifier.posterior = @SVM;
            
        case 'SVMlight'
            classifier.model = svmlearn(trainData, trainLabels, options.training);
            classifier.posterior = @SVMlight;
            
        case 'liblinear'
            classifier.model = train(trainLabels, sparse(trainData), options.training);
            classifier.posterior = @liblinear;

        case 'DA'
            classifier.model.traindata = trainData;
            classifier.model.labels = trainLabels;
            classifier.posterior = @DA;

        case 'jointBoosting'
             nWeakClassifiers = process_options(options.training, 'nWeakClassifiers', 6);
            [classifier.model.setidx, classifier.model.param, classifier.model.kc, classifier.model.sigA, classifier.model.sigB] = ...
                jointboostingtrain(trainLabels, trainData, nWeakClassifiers);
            classifier.posterior = @jointboosting;
            
        case 'cHMM'
            classifier.model.traindata = trainData;
            classifier.model = cHmmtrain(trainLabels, trainData, options.training);
            classifier.posterior = @cHMM;
            
        otherwise
            error('classifier not implemented');
    end
end

trainingTime = toc;