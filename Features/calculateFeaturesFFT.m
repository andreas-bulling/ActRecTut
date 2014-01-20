% fftFeatures = calculateFeaturesFFT(varargin)
%
% computes a number of features on a signal s, most of which are related to
% the FFT of the signal.
% Specifically it computes the following features:
% - FFT coefficients. Absolute, real values, grouped in logarithmic bands
% - 'c' cepstral coefficients
% - the spectral entropy
% - the energy as the sum of spectral coefficients
%
% s can be a matrix of column-signals, fftFeatures is a colum-vector.
% spec contains the spectra of each column-signal in each column
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

function fftFeatures = calculateFeaturesFFT(varargin)

if (isempty(varargin))
    fftFeatures = {'expBand1', 'expBand2', 'expBand3', 'expBand4', ...
        'ceptrCoeff1', 'ceptrCoeff2', 'ceptrCoeff3', 'ceptrCoeff4', 'ceptrCoeff5', ...
        'ceptrCoeff6', 'ceptrCoeff7', 'ceptrCoeff8', 'ceptrCoeff9', 'ceptrCoeff10', 'specEntropy', 'energy', 'empty', 'empty', 'empty'};
else
    s = imresize(varargin{1}, [50 size(varargin{1},2)]);
    c = 10; % TODO: hardcoded

    % preallocate feature vector
    fftFeatures = zeros(round(log2(size(s, 1)) + c + 3), size(s, 2));

    spec = abs(fft(s .* repmat(hamming(length(s)), 1, size(s, 2))));

    % divide the spectrum in exponential bands
    fftFeatures(1, :) = spec(1, :) ;
    curr = 2;
    start = 2; stop = 4;
    while stop <= length(s)/2
        fftFeatures(curr, :) = sum(spec(start:stop, :));
        curr = curr + 1;
        start = stop + 1;
        stop = stop * 2;
    end;

    % Cepstral Coefficients
    ceps = real(ifft(log(spec+1e-10)));
    fftFeatures(curr:curr+c-1, :) = ceps(1:c, :) ;
    curr = curr+c;

    % Spectral Entropy
    rspec = spec(1:round(length(s)/2), :) ;
    rspec = rspec + 1e-8;
    normlspecg = rspec./repmat(sum(rspec), size(rspec, 1), 1);
    fftFeatures(curr, :) = -1*sum(normlspecg .* log(normlspecg));
    curr = curr+1;

    % Energy
    fftFeatures(curr, :) = sum(spec(1:round(length(s)/2)),:);

    fftFeatures = reshape(fftFeatures, 1, []);
end
