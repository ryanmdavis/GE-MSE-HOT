% out1 = function hyperlink;  out2 = function string without hyperlink

function varargout = reconstructPfile_isFunLinkAvail(directory,exp_name,file_name)

file_path = strcat(directory,file_name,'_header.txt');

if ~exist(file_path)
    rdgehdr_dos_cmd = strcat({'C:\Users\Ryan2\Downloads\rdgehdr\rdgehdr "'},strcat(directory,file_name),{'" > "'},strcat(file_path,'"'));
    dos(rdgehdr_dos_cmd{:});
end

fields = struct('Series_description',' ','User_variable_42',' ','User_variable_47',0,'User_variable_48',0,'yres',16,'Last_series_number_used',0,'Scan_time',0);
fields = getGeHdrEntry(file_path,fields);
spect_flag=fields.User_variable_42;
tau=fields.User_variable_48;
tau_max=fields.User_variable_48;
opyres=fields.yres;
series_num=fields.Last_series_number_used;
scan_time=fields.Scan_time([1 2 4 5]);

switch fields.Series_description
case {'HOT','hot'}
    var_name=strcat(exp_name,'_HOT',num2str(series_num),'_',scan_time);
    if spect_flag==1
        start_to_exc_1 = {'<a href="matlab: '};
        expression_to_exc = {strcat('[',var_name,'] = getDirScanInfo_reconSpectrumPfile(''',directory,file_name,''');')};
        end_to_exc_1 = {strcat({'">Series #'},num2str(series_num),{' Time: '},fields.Scan_time,{' (HOT Spectrum)</a>'},{'    '})};
        fun_link_text_cell = strcat(start_to_exc_1,expression_to_exc{1},end_to_exc_1{1});
    else
        start_to_exc_2 = {'<a href="matlab: '};
        expression_to_exc = {strcat('[',var_name,'] = getDirScanInfo_reconImagePfile(''',directory,file_name,''');')};
        end_to_exc_2 = {strcat({'">Series #'},num2str(series_num),{' Time: '},fields.Scan_time,{' (HOT Image)</a>'},{'    '})};
        fun_link_text_cell = strcat(start_to_exc_2,expression_to_exc{1},end_to_exc_2{1});
    end
    parameters_link=strcat({'<a href="matlab: displayGEParametersFigure('''},{directory},{file_name},''')',{'">Parameters</a>'});
    param_and_function=strcat(fun_link_text_cell,{'   '},parameters_link);
    fun_link_text = param_and_function{1};
case 'PROBE-SV 35'
    var_name=strcat(exp_name,'_PROBE',num2str(series_num));
    start_to_exc_1 = {'<a href="matlab: '};
    expression_to_exc = {strcat('[',var_name,'] = getDirScanInfo_reconProbePfile(''',directory,file_name,''');')};
    end_to_exc_1 = {strcat({'">Series #'},num2str(series_num),{' (PROBE Spectrum)</a>'},{'    '})};
    fun_link_text_cell = strcat(start_to_exc_1,expression_to_exc{1},end_to_exc_1{1});
    fun_link_text = fun_link_text_cell{1};
otherwise
    fun_link_text='';
    expression_to_exc{1}='';
    var_name='';
end

if nargin>=1
    varargout{1}=fun_link_text;
end
if nargin>=2
    varargout{2}=expression_to_exc{1};
end
if nargin>=3
    varargout{3}=var_name;
end