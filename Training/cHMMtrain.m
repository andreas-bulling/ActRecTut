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

function model =  cHMMtrain(labels, data, options)
 t = [0.9 0.1   0;
        0 0.9 0.1;
        0   0   1];
 [mIter nStates nGauss mixmat trans prior] = process_options(options, ...
     'mIter', 10, 'nStates', 3, 'nGauss', 1, 'mixmat', [], 'trans',t, 'prior', [1 0 0]);
        
model.prior = cell(0); % each cell is one class
model.trans = cell(0);
model.mu = cell(0);
model.sigma = cell(0);
model.mixmat = cell(0);

left_right = 1;
cov_type = 'diag'; %  the less parameters the better.
nFeatures = size(data,2);
instances = splitIntoInstances(data, labels);
for iClass = unique(labels)'
    repetitions = instances{iClass};
   
    [mu sigma durations] = initializeLRHmm(repetitions, nStates, nFeatures);
    mu = reshape(mu, [nFeatures nStates nGauss]);
    %  Sigma(:,:,j,k) = Cov[Y(t) | Q(t)=j, M(t)=k]
    sigma = reshape(sigma, [nFeatures nFeatures nStates nGauss]);
    [LL model.prior{iClass}, ...
        model.trans{iClass}, ...
        model.mu{iClass}, ...
        model.sigma{iClass}, ...
        model.mixmat{iClass}] = mhmm_em(repetitions, prior, trans, mu, sigma, mixmat, 'max_iter', mIter, 'verbose', 0);
        model.windowMax{iClass} = max(durations);
        model.windowMin{iClass} = min(durations);
        model.windowAvg{iClass} = mean(durations);
end

% try different methods how to split data
% use single gaussian only.
%[mu0, Sigma0] = mixgauss_init(G*M,data(==label),cov_type);
%mu0 = 

%gausshmm_train_observed(obsData, hiddenData,  nstates, varargin)

function [mu sigma durations] = initializeLRHmm(repetitions, nStates, nFeatures)
    mu(1:nFeatures, 1:nStates) = inf;
    sigma(1:nFeatures, 1:nFeatures, 1:nStates) = inf;
    dataStates = cell(nStates, 1);
    durations(1:length(repetitions)) = -inf;
    for r = 1:length(repetitions)
        dataRep = repetitions{r}';
        T = size(dataRep, 1);
        durations(r) = T;
        divData = div(T, nStates);
        restData = mod(T, nStates);
        for s = 1:nStates
            start = (s-1) * divData + 1;
            stop = start-1 + divData;
            if s == nStates && restData~=0
                stop = start+restData -1;                
            end            
            dataStates{s} = [dataStates{s}; dataRep(start:stop, :)];
        end      
    end
    
    for s = 1:nStates
        mu(:, s) = mean(dataStates{s}, 1)';
        sigma(:, :, s) = cov(dataStates{s}, 1)'; 
    end