% TRANSFER_BOILER Boilerplate code for transfer functions.
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

if nargin < 1,error('NNET:Arguments','Not enough arguments.'); end

% BACKWARD COMPATIBILITY
if (ischar(in1))
  switch(in1)
  % NNT2
  case 'delta',
    if strcmp(fn,'hardlims')
      out1 = 'dhardlms';
    else
      out1 = ['d' fn];
    end
    nntobsu(fn,['Use ' upper(fn) ' to calculate transfer function derivatives.'], ...
      'Transfer functions now calculate their own derivatives.')
    return
  % NNT2
  case 'init',
    out1 = 'midpoint';
    nntobsu(fn,'Use network propreties to obtain initialization info.')
    return
  % NNT4
  case 'deriv'
    if strcmp(fn,'hardlims')
      out1 = 'dhardlms';
    else
      out1 = ['d' fn];
    end
    nntobsu(fn,['Use ' upper(fn) ' to calculate transfer function derivatives.'], ...
      'Transfer functions now calculate their own derivatives.')
    return
  end
end
% NNT2
if (nargin == 2) && isa(in1,'double')
  if isa(in2,'double') && ~isempty(in2)
    nntobsu(fn,['Use ' upper(fn) '(NETSUM(Z,B)) instead of ' upper(fn) '(Z,B).'])
    in1 = in1 + in2(:,ones(1,size(in1,2)));
  end
end

% CURRENT FUNCTIONALITY
if ischar(in1)
  switch (in1)
  case 'name', out1 = name;
  case 'output',
    if (nargin > 2), error('NNET:Arguments','Too many input arguments for action ''output''.'), end
    if (nargin < 2), in2 = param_defaults; elseif isa(in2,'cell'), in2=nnt_fpc2s(in2,param_defaults); end
    out1 = output_range(in2);
  case 'active',
    if (nargin > 2), error('NNET:Arguments','Too many input arguments for action ''active''.'), end
    if (nargin < 2), in2 = param_defaults; end
    out1 = active_input_range(in2);
  case 'fpnames',
    out1 = param_names;
  case 'fpdefaults',
    out1 = param_defaults;
  case 'fullderiv'
    out1 = isa(derivative(zeros(3,4),zeros(3,4),param_defaults),'cell');
  case 'dn',
    if nargin < 2, error('NNET:Arguments','Not enough input arguments for action ''dn''.'), end
    if (nargin < 4) || isempty(in4), 
        in4 = param_defaults; 
    elseif isa(in4,'cell'), 
        in4=nnt_fpc2s(in4,param_defaults); 
    end
    if (nargin < 3) || isempty(in3), in3 = apply_transfer(in2,in4); end
    out1 = derivative(in2,in3,in4);
  case 'check',
    if nargin < 2, error('NNET:Arguments','Not enough input arguments for action ''check''.'), end
    err = param_check(in2);
    if (nargout == 0)
      if ~isempty(err), error('NNET:Arguments',out1), end
    else
      out1 = err;
    end
  otherwise, error('NNET:Arguments',['Unrecognized code: ''' in1 ''''])
  end
  return
end
if nargin > 2, error('NNET:Arguments','Too many input arguments.'),end
if (nargin < 2) || isempty(in2), 
    in2 = param_defaults;
elseif isa(in2,'cell'), 
    in2=nnt_fpc2s(in2,param_defaults);
end
out1 = apply_transfer(in1,in2);
