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

p_experiments= {
    'expStudy_1_1chain_wrist',...
    'expStudy_1_2chain_alldata',...
    'expStudy_2_1_1features'...
    'expStudy_2_1features'...    
    'expStudy_2_2window',...
    'expStudy_2_2_1window',...
    'expStudy_2_3placements'...
    'expStudy_2_4modality_pd'... 
    'expStudy_2_4modality_pi'...
    'expStudy_3_1classifier',...
    'expStudy_3classifier',...
    'expStudy_4_1_1feature_selection',...% 20 features
    'expStudy_6_2adaption_classifier',...% using SVM
    'expStudy_6_2amount_train_classifier',...% using SVM
    'expStudy_special_feature_selection',...
    'expStudy_4_1_2_feature_selection_sweepset'...
    'expStudy_4_1_3_feature_selection_classes'
    };

for e = p_experiments
    eval(e{1});
end