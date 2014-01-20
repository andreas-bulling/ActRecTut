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

function cleanfields = prettyEvalLabels(fields)
%\ I know...
cleanfields = strrep(fields,'pd','');
cleanfields = strrep(cleanfields,'pi','');
cleanfields = strrep(cleanfields,'mat','');
cleanfields = strrep(cleanfields,'MAT','');
cleanfields = strrep(cleanfields,'value','');
cleanfields = strrep(cleanfields,'_','');
cleanfields = strrep(cleanfields,'gesture','');
cleanfields = strrep(cleanfields,'subject1','');
cleanfields = strrep(cleanfields,'subject2','');
cleanfields = strrep(cleanfields,'VerySimple','(\mu, \sigma)'); 
cleanfields = strrep(cleanfields,'Simple','(\mu, \sigma), MCR, ZCR'); 


cleanfields = strrep(cleanfields,'acc1acc2acc3gyr1gyr2gyr3','All');
cleanfields = strrep(cleanfields,'acc1acc2gyr1gyr2','Hand+lower arm');
cleanfields = strrep(cleanfields,'acc1acc3gyr1gyr3','Hand+upper arm');
cleanfields = strrep(cleanfields,'acc1gyr1','Hand');
cleanfields = strrep(cleanfields,'acc2acc3gyr2gyr3','lower+upper arm');
cleanfields = strrep(cleanfields,'acc2gyr2','lower arm');
cleanfields = strrep(cleanfields,'acc3gyr3','upper arm');

cleanfields = strrep(cleanfields,'acc1acc2acc3','All');
cleanfields = strrep(cleanfields,'acc1acc2','hand+lower arm');
cleanfields = strrep(cleanfields,'acc1acc3','hand+upper arm');
cleanfields = strrep(cleanfields,'acc2acc3','lower+upper arm');
cleanfields = strrep(cleanfields,'acc1','Hand');
cleanfields = strrep(cleanfields,'acc2','lower arm');
cleanfields = strrep(cleanfields,'acc3','upper arm');
cleanfields = strrep(cleanfields,'gyr1gyr2gyr3','All');
cleanfields = strrep(cleanfields,'gyr1gyr2','hand+lower arm');
cleanfields = strrep(cleanfields,'gyr1gyr3','hand+upper arm');
cleanfields = strrep(cleanfields,'gyr2gyr3','lower+upper arm');
cleanfields = strrep(cleanfields,'gyr3','upper arm');
cleanfields = strrep(cleanfields,'gyr2','lower arm');
cleanfields = strrep(cleanfields,'gyr1','hand');

cleanfields = strrep(cleanfields,'knnVoting','knn');
cleanfields = strrep(cleanfields,'NaiveBayes','NB');
cleanfields = strrep(cleanfields,'jointBoosting','JB');
cleanfields = strrep(cleanfields,'cHMM','HMM');