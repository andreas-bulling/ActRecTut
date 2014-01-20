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

function SETTINGS = setClassifier(classifier, SETTINGS, varargin)

SETTINGS.CLASSIFIER = classifier;
assert(length(varargin) == 2 || isempty(varargin));
if length(varargin) == 2
    [training test] = process_options(varargin, 'training', [], 'test', []);
     SETTINGS.CLASSIFIER_OPTIONS.training = training;
     SETTINGS.CLASSIFIER_OPTIONS.testing = test;
     return;
end

% default
switch classifier % classifier parameters
    case 'knnVoting' % main parameter: number of nearest neighbours (k), default 5
        SETTINGS.CLASSIFIER_OPTIONS.training = [];
        SETTINGS.CLASSIFIER_OPTIONS.testing = {'k', 1};
        
    case 'SVM' % see libSVM documentation
        SETTINGS.CLASSIFIER_OPTIONS.training = '-c 1 -g 0.07 -b 1';
        SETTINGS.CLASSIFIER_OPTIONS.testing = '-b 1';
        
    case 'SVMlight' % see SVMlight documentation
        SETTINGS.CLASSIFIER_OPTIONS.training = '-c 1 -g 0.07 -t 2'; % use RBF by default
        SETTINGS.CLASSIFIER_OPTIONS.testing = '';
        
    case 'liblinear' % see liblinear documentation
        SETTINGS.CLASSIFIER_OPTIONS.training = '-s 4 -c 1 -e 0.1';
        SETTINGS.CLASSIFIER_OPTIONS.testing = '';
        
    case 'NaiveBayes' % see "doc naivebayes.fit"
        SETTINGS.CLASSIFIER_OPTIONS.training = {'Distribution', 'normal'};
        SETTINGS.CLASSIFIER_OPTIONS.testing = [];
                
    case 'jointBoosting'
        SETTINGS.CLASSIFIER_OPTIONS.training = {'nWeakClassifiers', 80};
        SETTINGS.CLASSIFIER_OPTIONS.testing = [];
        SETTINGS.FEATURE_SELECTION = 'none'; % jointBoosting has its own feature selection
        
    case 'cHMM'
        % watch out: 0 elements will never change and sets HMM structure, here:
        % L-R without periodicity (no transition back to the first
        t = [0.9 0.1   0;
               0 0.9 0.1;
               0   0   1];
        SETTINGS.CLASSIFIER_OPTIONS.training = {'mIter', 10, 'nStates', 3, 'nGauss', 1, ...
            'mixmat', [], 'trans', t, 'prior', [1 0 0]};
        clear t;        
        SETTINGS.CLASSIFIER_OPTIONS.testing = {'wSize', 40, 'wStep', 10};
        
    otherwise
        SETTINGS.CLASSIFIER_OPTIONS.training = [];
        SETTINGS.CLASSIFIER_OPTIONS.testing = [];
end