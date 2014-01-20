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

function [features fType fDescr segments segmentation labelsSegmentation featureLabels SETTINGS] = prepareFoldData(SETTINGS, varargin)

switch SETTINGS.EVALUATION
    case 'pi'
        subjectsFeatures = cell(0);
        subjectsSegments = cell(0);
        subjectsSegmentation = cell(0);
        subjectsLabelsSegmentation = cell(0);
        subfolds = cell(0);

        for iSubject = 1:SETTINGS.SUBJECT_TOTAL
            loadname = sprintf('%s/subject%d_%s/data.mat', SETTINGS.PATH_DATA, iSubject, SETTINGS.DATASET);
            if SETTINGS.VERBOSE_LEVEL >= 2
                fprintf('\nLoading dataset %s\n', loadname);
            end
            
            if exist(loadname, 'file')
                load(loadname);
            else
                error('prepareFoldData:fileDoesNotExist', [loadname ' does not exist in the file system.']);
            end
            
            % remap to one-vs-all
            if ~isempty(SETTINGS.ONEVSALL)
                labels(labels~=SETTINGS.ONEVSALL)=1;
                labels(labels==SETTINGS.ONEVSALL)=2;
            end
            
            [subjectsFeatures{iSubject} fType fDescr subjectsSegments{iSubject} subjectsSegmentation{iSubject} ...
                subjectsLabelsSegmentation{iSubject} featureLabels] = run_preprocess(data, labels, labeling2segments(labels, 0), SETTINGS);  
            subfolds{iSubject}(:, 1) = 1:size(subjectsFeatures{iSubject}, 1);  
            
            % TODO: unify segmentation offset somwhere
            for s = 2:length(subjectsSegments{iSubject}) 
                subjectsSegments{iSubject}{s} = subjectsSegments{iSubject}{s-1}(end,2) + subjectsSegments{iSubject}{s}(:,1:2);
            end
            
            for s = 2:length(subjectsSegmentation{iSubject}) 
                subjectsSegmentation{iSubject}{s} = subjectsSegmentation{iSubject}{s-1}(end,2) + subjectsSegmentation{iSubject}{s}(:,1:2);
            end
        end

        % add random part to training set                
        features = mrt(subjectsFeatures)'; % flatten
        segments = mrt(subjectsSegments)';
        segmentation = mrt(subjectsSegmentation)';
        labelsSegmentation = mrt(subjectsLabelsSegmentation)';
        
        for s = 2:length(subfolds) % update subfold indices
          subfolds{s} = subfolds{s-1}(end) + subfolds{s};
        end
     
       % for s = 2:length(segments) % update start indices
       %   segments{s}(:,1:2) = segments{s-1}(end,2) + segments{s}(:,1:2);
       % end
        
       % for s = 2:length(segmentation) % update subfold indices
       %   segmentation{s}(:,1:2) = segmentation{s-1}(end,2) + segmentation{s}(:,1:2);
       % end

        SETTINGS.FOLDS = subfolds;
        return;
        
    case 'pd'        
        loadname = sprintf('%s/subject%d_%s/data.mat', SETTINGS.PATH_DATA, SETTINGS.SUBJECT, SETTINGS.DATASET);
        if SETTINGS.VERBOSE_LEVEL >= 2
            fprintf('\nLoading dataset %s\n', loadname);
        end
        
        if exist(loadname, 'file')
            load(loadname);
        else
            error('prepareFoldData:fileDoesNotExist', [loadname ' does not exist in the file system.']);
        end
        % remap to one-vs-all
        if ~isempty(SETTINGS.ONEVSALL)
            labels(labels~=SETTINGS.ONEVSALL)=1;
            labels(labels==SETTINGS.ONEVSALL)=2;
        end
        [features fType fDescr segments segmentation labelsSegmentation featureLabels] = ...
            run_preprocess(data, labels, labeling2segments(labels, 0), SETTINGS);
        return;
    case 'customfolds'
        foldFeatures = cell(0);
        foldSegments = cell(0);
        foldSegmentation = cell(0);
        foldLabelsSegmentation = cell(0);
        subfolds = cell(0);
        
        [foldLabelsFileLocation foldDataFileLocation] = process_options(varargin, 'foldLabelsFileLocation', [], 'foldDataFileLocation', []);
       
        nFolds = length(foldLabelsFileLocation) % 'Data/tamsdata/day1-data.txt'
        for f = 1:nFolds
            data = load(foldDataFileLocation{f});
            labels = load(foldLabelsFileLocation{f});
            if sum(labels==0)>0 % labels should start with 1
                labels = labels + 1; 
            end
             [foldFeatures{f} fType fDescr foldSegments{f} foldSegmentation{f} ...
                foldLabelsSegmentation{f} featureLabels] = run_preprocessV2(data, labels, labeling2segments(labels, 0), SETTINGS);  
            subfolds{f}(:, 1) = 1:size(foldFeatures{f}, 1);  
            
            % TODO: unify segmentation offset somwhere
            for s = 2:length(foldSegments{f}) 
                foldSegments{f}{s} = foldSegments{f}{s-1}(end,2) + foldSegments{f}{s}(:,1:2);
            end
            
            for s = 2:length(foldSegmentation{f}) 
                foldSegmentation{f}{s} = foldSegmentation{f}{s-1}(end,2) + foldSegmentation{f}{s}(:,1:2);
            end
        end
        
         % add random part to training set                
        features = mrt(foldFeatures)'; % flatten
        segments = mrt(foldSegments)';
        segmentation = mrt(foldSegmentation)';
        labelsSegmentation = mrt(foldLabelsSegmentation)';
        
        for s = 2:length(subfolds) % update subfold indices
          subfolds{s} = subfolds{s-1}(end) + subfolds{s};
        end
     
        SETTINGS.FOLDS = subfolds;
        return;              
       
    otherwise
        error('Unknown fold type');
end