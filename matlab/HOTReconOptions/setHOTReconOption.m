function setHOTReconOption(varargin)
if mod(nargin,2) %is odd?
    error('inputs must come as name value pairs');
end

% a list of valid options that can be set by this function:
valid_options={'num_echoes_avg','recon_size','data_type','display','decomposition','decomposition_scan','fermi_T','fermi_E','weight_iZQC','row_shift','col_shift'};

% check if option is valid
for name_num=1:2:nargin
    option=varargin{name_num};
    option_is_valid=0;
    for option_num=1:size(valid_options,2)
        if strcmp(option,valid_options{option_num})
            option_is_valid=1;
            break
        end
    end
    if ~option_is_valid error(char(strcat({'setHOTReconOption: '},{option},{' is not a valid option'}))); end %#ok<SEPEX>
end

% path to the .mat file that holds the recon options
load(hotPath('options'));

% check if value is valid and save to structure
for name_num=1:2:nargin
    option=varargin{name_num};
    value=varargin{name_num+1};
    value=setHOTReconOption_checkValue(option,value);
    if ~isempty(value)
        s.(option)=value; %#ok<STRNU>
    end
end

% save structure to file
save(hotPath('options'),'s');