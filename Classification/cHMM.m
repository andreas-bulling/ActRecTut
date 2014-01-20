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

function scores = cHMM(model, data, options)

 [wSize wStep] = process_options(options.testing, 'wSize', 40, 'wStep', 10);

nModels = length(model.prior);

% decision window size
% comparability requires equal size classification window!!!

nSamples = size(data,1);

scores(1:nSamples,1:nModels) = -inf;
likelihoods = zeros(1, nModels);

for s=1:wStep:nSamples

    if (s+wSize<nSamples)
        frames = s:s+wSize;
    else
        frames = s:nSamples;
    end
    d = data(frames, :);
    likelihoods(1, nModels) = -inf;
    for m = 1:nModels    
        loglik = mhmm_logprob(d', model.prior{m}, model.trans{m}, model.mu{m}, model.sigma{m}, model.mixmat{m});
        likelihoods(1, m) = loglik;
    end
   
    scores(frames,:) = max(scores(frames,:), repmat(likelihoods, [length(frames), 1])); 
end
%{
% OLD VERSION: unfair splitting
[instances segments] = splitIntoInstances(data, varargin{1}.labels);

scores(1:max(segments(:,2)),1:nModels) = -inf;
for s=1:size(segments,1)
    d = data(segments(s,1):segments(s,2),:);
    likelihoods(1, 1:size(instances, 2)) =  0;
    for m=1:nModels    
        loglik = mhmm_logprob(d',...
            model.prior{m},...
            model.trans{m},...
            model.mu{m},...
            model.sigma{m},...
            model.mixmat{m});
        likelihoods(1,m) = loglik;
    end
    frames = segments(s,1):segments(s,2);
    scores(frames,:) = repmat(likelihoods, [length(frames), 1]); % inflate 
end
%}
