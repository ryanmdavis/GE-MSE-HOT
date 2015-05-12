% This function searches the data path (see hotPath(...)) for an directory
% specified by 'exp_name'
% inputs:
%   exp_name: experiment name.  For example if Bruker patient name is
%   RMD276, then passing 'RMD276' will print out all scans under this
%   folder
%
%   optional arguments:
%   if an array of numbers is passed: reconstruct() will construct all scan
%       numbers specified by the array.  e.g. reconstruct('RMD276',7) will
%       reconstruct Scan 7 from experiment RMD276
%   if a string is passed: reconstruct() will print out the value of the
%       string in the meth or acqp file.  e.g. reconstruct('RMD276','BF1') will
%       print out the basic frequence (BF1) for all scans in experiment RMD276
%   note: both cases above can be used simultaneously. e.g.
%       reconstruct('RMD276',7,'BF1') will reconstruct Sc 7 and print the value
%       of BF1 at the command line
%
%   output:
%   depends on the optional arguments, but reconstruct(...) can 1)
%   reconstruct a specified dataset 2) print header data 3) print a
%   hyperlink at the command line that, if clicked, will reconstruct the
%   Bruker data.
    
function reconstruct(exp_name,varargin)

invar = varargin;
default_fields_bruker = {'Method','Exp_type'};
default_fields_ge = {'SeriesDescription','PixelBandwidth'};

DATA_PATH = hotPath('images');
directory = searchForFolderInPath(DATA_PATH,exp_name);
if ~isempty(strfind(directory,'GE'))||~isempty(strfind(directory,'OpenSuse'))
    datasets = printScansGE(directory,default_fields_ge,invar,exp_name);
else
    datasets = printScansBruker(directory,default_fields_bruker,invar,exp_name);
end

% now push again all data structures to caller workspace
w=whos;
for variable_num=1:size(w,1)
    if ~isempty(strfind(w(variable_num).name,exp_name))
        assignin('caller',w(variable_num).name,eval(w(variable_num).name));
        clear(w(variable_num).name);
    end
end
end

function [exp_name,exp_name_full] = findExpNameGE(directory)
i = strfind(directory,'_');
if ~isempty(i)
    last_dot_ind = i(end);
    slash_corr = 0;
    if strcmp(directory(end),'\')
        slash_corr = 1;
    end
    exp_name = directory(last_dot_ind+1:end-slash_corr);
    exp_name_full = directory(last_dot_ind:end);
else
    exp_name = [];
end
end

function s = rmDot(exp_name_full)
i = strfind(exp_name_full,'.');
s = strcat(exp_name_full(1:(i-1)),'_',exp_name_full(i+1:end));
end

function datasets = printScansBruker(directory,default_fields,invar,exp_name)

datasets = struct;
d = dir(directory);
folders_only(1) = d(1);
folder_only_index = 1;
for d_field_num = 1:size(d,1)
    if d(d_field_num).isdir && exist([directory '\' d(d_field_num).name '\method'],'file') && exist([directory '\' d(d_field_num).name '\acqp'],'file')
        folders_only(folder_only_index) = d(d_field_num);
        folder_only_index = folder_only_index + 1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Separate 1)method vars to be printed and 2) folders to print:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
scans_to_print = [];
extra_fields = cell(0);
exc_flag=0;
for i = 1:size(invar,2)
    if isstr(invar{i}) extra_fields{size(extra_fields,2)+1} = invar{i};
    else
        scans_to_print=[scans_to_print invar{i}];
        exc_flag=1;
    end
end
        
for folder_num = 1:size(folders_only,2)
    %% clear the fields structure:
    fields_cell = cat(2,default_fields,extra_fields);
    for field_num = 1:size(fields_cell,2)
        fields.(fields_cell{field_num}) = [];
    end
    
    fields = getPVEntry3([directory '\' folders_only(folder_num).name '\acqp'],fields);
    fields = getPVEntry3([directory '\' folders_only(folder_num).name '\method'],fields);
    
    %% generate the display string and function hyperlink
    display_string=cell(1,size(fieldnames(fields),1)+1);
    display_string{1} = reconstruct_hyperlink(directory,fields,folders_only(folder_num).name,exp_name);

    for entry_num = 1:size(fields_cell,2)%%chagnge this to include default entries
        display_string{entry_num+1} = strcat(fields_cell{entry_num},{': '},num2str(fields.(fields_cell{entry_num})),{'    '});
    end
    display_string=reconstruct_alignCol(display_string,1:30:(30*size(display_string,2)+1));
    datasets.(strcat('s',folders_only(folder_num).name)) = display_string;
    
    % if this scan was given by the caller as a scan to print and execute
    if (isempty(scans_to_print) || (sum(str2double(folders_only(folder_num).name) == scans_to_print) == 1))
        display(display_string{1:end});
        if (exc_flag) %if scan numbers are specified then go ahead and run the reconstruction
            display_string_str=display_string{1};
            bracket_loc=strfind(display_string_str,'[');
            semicolon_loc=strfind(display_string_str,';');
            for cmd_num=1:size(semicolon_loc,2)
                % note that this line does not write to base workspace, but
                % to the main reconstruct workspace.  Structures
                % generated by this line will be pushed from reconstruct
                % workspace to base
                evalin('caller',display_string_str((bracket_loc(cmd_num)):semicolon_loc(cmd_num)));
            end
        end
    end
end
end

function fields = populateDicomFields(fields,fields_location)

    fields_all = dicominfo(fields_location);
    field_names = fieldnames(fields);
    for field_num = 1:size(field_names,1)
        fields.(field_names{field_num}) = fields_all.(field_names{field_num});
    end
end


function datasets = printScansGE(directory,default_fields,invar,exp_name)

%Separate 1)method vars to be printed and 2) folders to print:
scans_to_print = [];
extra_fields = cell(0);
exc_flag=0;
for i = 1:size(invar,2)
    if isstr(invar{i}) extra_fields{size(extra_fields,2)+1} = invar{i};
    else
        scans_to_print=[scans_to_print invar{i}];
        exc_flag=1;
    end
end

% define and set to zero all fields to be read from header
fields_cell = cat(2,default_fields,extra_fields);
for field_num = 1:size(fields_cell,2)
    fields.(fields_cell{field_num}) = [];
end

datasets = struct;
d = dir(directory);
folders_only(1) = d(1);
folder_only_index = 1;
first_dicom_file_name = cell(1);

if ~isempty(strfind(d(3).name,'.dcm'))
    datasets = printScansGE_dicom(directory,d,fields,exp_name);
else
    datasets = printScansGE_pfile(directory,d,fields,exp_name,scans_to_print,exc_flag);    
end

% now push again all data structures to caller workspace
w=whos;
for variable_num=1:size(w,1)
    if ~isempty(strfind(w(variable_num).name,exp_name))
        assignin('caller',w(variable_num).name,eval(w(variable_num).name));
        clear(w(variable_num).name);
    end
end

end

function datasets = printScansGE_pfile(directory,d,fields,exp_name,scans_to_print,exc_flag)
    pfile_only_index = 1;

    %now go through all of the experiments that were found in the directory
    %and print the hyperlink
    for d_field_num = 1:size(d,1)

        i=[];
        j=1;

        i = strfind(d(d_field_num).name,'.7');
        j = strfind(d(d_field_num).name,'.txt');
        k = strfind(d(d_field_num).name,'PBIA');

        %%%only folders that have dicom files go into folders_only
        if (~isempty(i)||~isempty(k)) && isempty(j)
            pfile_only(pfile_only_index) = d(d_field_num);
            pfile_only_index = pfile_only_index + 1;
        end
    end
    
    for pfile_num = 1:size(pfile_only,2)
        %structure can't have dot in it
        file_name = pfile_only(pfile_num).name;
        dot_loc = strfind(file_name,'.');
%         if isempty(dot_loc)
%             exp_name=file_name;
%         else
%             exp_name = file_name(1:(dot_loc-1));
%         end
        datasets.(exp_name) = reconstructPfile_isFunLinkAvail(directory,exp_name,file_name);

        
        %if scan numbers are specified while calling reconstruct(...) then 
        %go ahead and run the reconstruction
        series_field = struct('Last_series_number_used',0);
        series_field = getGeHdrEntry(strcat(directory,file_name,'_header.txt'),series_field);
        if (isempty(scans_to_print) || (sum(series_field.Last_series_number_used == scans_to_print) == 1))
            if ~isempty(datasets.(exp_name))
                display(datasets.(exp_name));
            end
            if (exc_flag) %if scan numbers are specified then go ahead and run the reconstruction
                display_string_str=datasets.(exp_name);
                bracket_loc=strfind(display_string_str,'[');
                bracket_loc_end=strfind(display_string_str,']');
                semicolon_loc=strfind(display_string_str,';');
                var_name=display_string_str(bracket_loc+1:bracket_loc_end-1);
                for cmd_num=1:size(semicolon_loc,2)
                    % note that this line does not write to base workspace, but
                    % to the main reconstruct workspace.  Structures
                    % generated by this line will be pushed from reconstruct
                    % workspace to base
                    evalin('caller',display_string_str((bracket_loc(cmd_num)):semicolon_loc(cmd_num)));
                end
            end
        end
    end
end

function datasets = printScansGE_dicom(directory,d,fields,exp_name)

folder_only_index = 1;
for d_field_num = 3:size(d,1)
    sub_d = dir([directory d(d_field_num).name]);
    i = [];
    sub_d_index = 0;
    while (isempty(i) && (sub_d_index<size(sub_d,1)))
        sub_d_index = sub_d_index + 1;
        i = strfind(sub_d(sub_d_index).name,'series');
    end
    dicom_in_folder = 1;
    if isempty(i) %if had to look at all files in the folder and still not find dicom
        dicom_in_folder = 0;
    end
    
    %%%only folders that have dicom files go into folders_only
    if dicom_in_folder
        folders_only(folder_only_index) = d(d_field_num);
        first_dicom_file_name{folder_only_index} = sub_d(sub_d_index).name;
        folder_only_index = folder_only_index + 1;
    end
end

for folder_num = 1:size(folders_only,2)
    fields_location = strcat(directory,folders_only(folder_num).name,'\',first_dicom_file_name{folder_num});

    fields = populateDicomFields(fields,fields_location);
    display_string = reconstructGE_isFunLinkAvail(directory,fields,folders_only(folder_num).name,exp_name);
    if isempty(display_string)
        display_string = strcat('Scan',{' '},folders_only(folder_num).name,{':    '});
    else
        display_string = strcat(folders_only(folder_num).name,': ',display_string,{'    '});
    end
    for entry_num = 1:size(fields_cell,2)%%chagnge this to include default entries
        display_string = strcat(display_string,fields_cell{entry_num},{': '},num2str(fields.(fields_cell{entry_num})),{'    '});
    end
    datasets.(strcat('s',folders_only(folder_num).name)) = display_string;
    display(display_string{1:end});
end
end