%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


function full_dir = getFullDirFromExpNum(exp_name,varargin)
if nargin == 2
    parent_directory = varargin{1};
else
    parent_directory = 'C:\Ryan MR Data\Data';
end
experiments = dir(parent_directory);
full_dir = '';
%%% Search through parent directory for exp_name and return full directory:
for exp_num = 1:size(experiments,1) 
    if strfind(experiments(exp_num).name,exp_name) full_dir = strcat(parent_directory,'\',experiments(exp_num).name,'\'); end
end