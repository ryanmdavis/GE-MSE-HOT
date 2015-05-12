%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


% returns the file location of various data needed for reconstruction of
% HOT data.
function path=hotPath(type)

% find the location of the parent directory
file_loc=mfilename('fullpath');
repo_name='\GE MSE-HOT\';
parent_dir_end=strfind(file_loc,repo_name)+size(repo_name,2)-1;
parent_dir=file_loc(1:parent_dir_end);

% return the full directory based on what the user is looking for
if ~strcmp(parent_dir(end),'\'), parent_dir=strcat(parent_dir,'\'); end
switch type
    case 'images'
        % path type: cell array of directories.  the function getDirScanInfo
        % searches these directories for image data
        path={strcat(parent_dir,'GE data')};
    case 'luxtron'
        % path type: directory of luxtron (fiberoptic thermometer) data
        path=strcat(parent_dir,'Luxtron data');
    case 'calibration'
        % path type: file
        % contents: 
        %   nu_of_T: linear mapping of iZQC frequency (nu) to temperature
        %       (T)
        %   T_of_nu: linear mapping of temperature to iZQC frequency
        %   S_of_TE: the average complex signal of fat-water iZQC in red
        %       marrow.  Used for weighted averaging of echoes
        path=strcat(parent_dir,'calibration\hot calibration curves.mat');
    case 'roi'
        path=strcat(parent_dir,'ROIs');
    case 'options'
        path=strcat(parent_dir,'recon options\HOTReconOptions.mat');
    case 'sim'
        path=strcat(parent_dir,'simulation results\');
    otherwise
        error('path must be either "images", "luxtron", "options", "roi", "sim" or "calibration"');
end 