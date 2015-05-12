%return data as raw(coil_num,echo_num,phase,read);

function [raw,varargout] = readGE2DRaw(file_path)%,opxres,opyres,num_echo,num_coils)
% invar = struct('edr',1);
% argin = varargin;
% invar = generateArgin(invar,argin);
fid=fopen(file_path,'r','l'); %opens the little endian data file

if ~exist(strcat(file_path,'_header.txt'))
    rdgehdr_dos_cmd = strcat({'C:\Users\Ryan2\Downloads\rdgehdr\rdgehdr "'},file_path,{'" > "'},file_path,'_header.txt"');
    dos(rdgehdr_dos_cmd{:});
end

%read header to see if EDR flag is on
hdr_txt_file = strcat(file_path,'_header.txt');
hdr = textread(hdr_txt_file,'%c')';
edr_flag = ~isempty(strfind(hdr,'(EDR)'));

%read information about data size:
scan_params = struct('Coil_name',[],'rhnecho',[],'xres',[],'yres',[],'variable_46',[],'variable_47',[]);
scan_params = getGeHdrEntry(hdr_txt_file,scan_params);
opxres = scan_params.xres;
opyres = scan_params.yres;
num_echo = scan_params.rhnecho;
num_coils = coilName2NumCoils(scan_params.Coil_name);

%%find how big header is:
fseek(fid,1468,'bof');
ge_header_size = fread(fid,1,'int32');

n_baseline_views = 2*num_coils;

%the 2*2*opxres*num_coils term is because apparently GE puts an extra view
%right before the data for each coil.  One 2 is for real/imag, the other is
%because they are int16
data_start_byte = ge_header_size + n_baseline_views * 2 * opxres - 2*2*opxres*(num_coils) - 1; % dont read header or baseline views

%find how big file is and word size
fseek(fid,data_start_byte,'bof');
if edr_flag
    raw_data = fread(fid,inf,'int32');
else
    raw_data = fread(fid,inf,'int16');
end
if 2*opxres*(opyres+1)*num_echo*num_coils ~= size(raw_data,1) 
    error('incorrect matrix dimensions specified at input to readGE2DRaw');
end
data_com = raw_data(1:2:end) + 1i*raw_data(2:2:end); % just get data from one coil

data_2d = reshape(data_com,opxres,opyres+1,num_echo,num_coils);
raw = squeeze(data_2d(:,2:end,:,:));
raw = permute(raw,[5 4 3 2 1]);
% raw = flipdim(raw,3); 

fclose(fid);

if nargout == 2
    varargout{1} = scan_params;
end
end