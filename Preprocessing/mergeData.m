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

close all;
clear all;

datafolder = 'Data/';

files = {
    '131';
    '111';
    '125';
%    '112'; % excluded for gesture datasets
};

subjects = {
%    'subject1_gesture';
    'subject2_gesture';
%    'subject1_walk';
%    'subject2_walk';
};

for iSubject = subjects'
    data = [];
    
    for iFile = files'
        loadname = [datafolder iSubject{:} '/S' iFile{:} '.dat'];
        disp(['Loading ' loadname ' ...']);
        
        if( exist(loadname, 'file') )
            temp = load(loadname);
            acc = temp(:, [4 5 6]);
            gyr = temp(:, [7 8 9]);
            data = [data acc gyr];
        end
    end
    
    % 0/32: NULL, 39: smash, 48: backhand, 49: open window, 50: drink, 51:
    % water plant, 52: close window, 53: cut, 54: chop, 55: stir, 56: book,
    % 57: forehand
    class_list = [49 50 51 52 53 54 55 56 57 48 39]; % 0/32 not included => becomes NULL, changed order to match notes.txt
    
    loadname = [datafolder iSubject{:} '/labels.dat'];
    labels = load(loadname);
    labels = convert_labels(labels, class_list);
    % shift labels to 1...n
    labels = labels + 1;
    
    if( strcmp(iSubject{:}, 'subject1_gesture') )
        % fix labels
        labels(1:8000) = 0;
    end

    if( strcmp(iSubject{:}, 'subject2_gesture') )
        % fix labels
        labels(1644:1682) = 0;
    end
    
    if( max(merged(:,2)) > 50 )
        disp('wrong labels detected');
    else
        data = data(:, [5:10 13:18 21:26]);
        data = imputeFeatureMatrix(data, labels);

        savename = ['Data/' iFile{:} '/processed.mat'];
        save(savename, 'data', 'labels');
        disp(['Saving ' savename ' ...']);
    end
end