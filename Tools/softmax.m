%SOFTMAX Soft max transfer function.
%	
%	Syntax
%
%	  A = softmax(N,FP)
%   dA_dN = softmax('dn',N,A,FP)
%	  INFO = softmax(CODE)
%
%	Description
%	
%	  SOFTMAX is a neural transfer function.  Transfer functions
%	  calculate a layer's output from its net input.
%
%	  SOFTMAX(N,FP) takes N and optional function parameters,
%	    N - SxQ matrix of net input (column) vectors.
%	    FP - Struct of function parameters (ignored).
%	  and returns A, the SxQ matrix of the softmax competitive function
%   applied to each column of N.
%	
%   SOFTMAX('dn',N,A,FP) returns SxSxQ derivative of A w-respect to N.
%   If A or FP are not supplied or are set to [], FP reverts to
%   the default parameters, and A is calculated from N.
%
%   SOFTMAX('name') returns the name of this function.
%   SOFTMAX('output',FP) returns the [min max] output range.
%   SOFTMAX('active',FP) returns the [min max] active input range.
%   SOFTMAX('fullderiv') returns 1 or 0, whether DA_DN is SxSxQ or SxQ.
%   SOFTMAX('fpnames') returns the names of the function parameters.
%   SOFTMAX('fpdefaults') returns the default function parameters.
%
%	Examples
%
%	  Here we define a net input vector N, calculate the output,
%	  and plot both with bar graphs.
%
%	    n = [0; 1; -0.5; 0.5];
%	    a = softmax(n);
%	    subplot(2,1,1), bar(n), ylabel('n')
%	    subplot(2,1,2), bar(a), ylabel('a')
%
%	  Here we assign this transfer function to layer i of a network.
%
%     net.layers{i}.transferFcn = 'softmax';
%
%   Algorithm
%
%       a = softmax(n) = exp(n)/sum(exp(n))
%
%	See also SIM, COMPET.

% Mark Beale, 11-31-97
% Updated by Orlando De Jes�s, Martin Hagan, 7-20-05
% Copyright 1992-2007 The MathWorks, Inc.
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

function out1 = softmax(in1,in2,in3,in4)

fn = mfilename;
boiler_transfer

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Name
function n = name
n = 'Soft Max';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Output range
function r = output_range(fp)
r = [0 1];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Active input range
function r = active_input_range(fp)
r = [-inf +inf];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameter Defaults
function fp = param_defaults(values)
fp = struct;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameter Names
function names = param_names
names = {};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameter Check
function err = param_check(fp)
err = '';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Apply Transfer Function
function a = apply_transfer(n,fp)
% Note - calculating numerator and denominator separately
% avoids a "Rank deficient" warning in some cases.
% Example - softmax([0 inf; -1 1])
s = size(n,1);
numer = exp(n);
denom = sum(numer,1); 
denom = denom + (denom==0); 
denom = 1./denom; 
a = numer .* denom(ones(1,s),:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Derivative of Y w/respect to X
function da_dn = derivative(n,a,fp)
[Sm,Q] = size(a);
da_dn = cell(1,Q);
for q=1:Q
  da_dn{q} = diag(a(:,q))*sum(a(:,q)) - kron(a(:,q)',a(:,q));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
