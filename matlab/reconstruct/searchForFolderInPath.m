%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


function directory = searchForFolderInPath(DATA_PATH,folder_name)

% DATA_PATH = {'C:\Users\Ryan\Documents\Warren Lab Work\Bruker 7T data',
%             'C:\Ryan MR Data\Data'};
%%%Find the file location of the experiment:
data_path_dir_num = 1;
directory = '';
while strcmp(directory,'') && data_path_dir_num <= size(DATA_PATH,1)
    full_dir = getFullDirFromExpNum(folder_name,DATA_PATH{data_path_dir_num});
    if exist(DATA_PATH{data_path_dir_num},'dir') && ~isempty(full_dir)
        directory = full_dir;
    end
    data_path_dir_num = data_path_dir_num + 1;
end