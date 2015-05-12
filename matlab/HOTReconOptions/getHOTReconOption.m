function value=getHOTReconOption(option)

% a list of valid options that can be set by this function:
load(hotPath('options'));
valid_options=fieldnames(s);

% path to the .mat file that holds the recon options
option_is_valid=0;
for option_num=1:size(valid_options,1)
    if strcmp(option,valid_options{option_num})
        option_is_valid=1;
        break
    end
end

if ~option_is_valid error(char(strcat({'getHOTReconOption: '''},{option},{''' is not a valid option'}))); end
value=s.(option);