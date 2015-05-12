%reconGeHotTemp2 reconstructs temperature image with the following
%coherence orders - SQ - iZQC - iZQC - iZQC....

function out = reconGeHotTemp2(path,varargin)

%% optional function arguments
invar = struct('disp',0,'fermi',1,'data_type','image','recon_elem',0,'shift',[0 0],'evolution_time',[]);
argin = varargin;
invar = generateArgin(invar,argin);

%% read and fft raw data
raw = readGE2DRaw(path);
upsample_factor=getHOTReconOption('recon_size')/size(raw,5);

%% read info about image
fields = struct('Coil_name',[],'rhnecho',[],'xres',[],'yres',[],'variable_46',[],'variable_47',[],'Scan_time',[],'Frequency_direction',[]);
fields = getGeHdrEntry(strcat(path,'_header.txt'),fields);

%% arrange data based on frequency encode direction
switch fields.Frequency_direction(1)
    case '1'
        raw=permute(raw,[1 2 3 4 5]);
    otherwise
        raw=permute(raw,[1 2 3 5 4]);
end
images = fftshift(fftshift(ifft(ifft(fftshift(fftshift(raw,4),5),[],4),[],5),4),5);
images=upsampleImage(images,upsample_factor);
images = circshift(images,[0 0 0 invar.shift]);
images=upsampleImage(images,1/upsample_factor);

if strfind(path,'RMD332')
    images = scanSpecificAdjustment(images,1);
end


if isempty(invar.evolution_time)
    t1 = fields.variable_46/1000; %divide by 1000 converts microseconds to milliseconds
    tau = fields.variable_47/1000;
    time_evolution_ms = t1+tau;
else 
    time_evolution_ms=invar.evolution_time;
end

%% assemble phased array data if is a coil array:
if coilName2NumCoils(fields.Coil_name) > 1
    display('Assembling data from the coil elements');
    images = assemblePhasedNMRDataHOT2(images,invar.data_type,invar.recon_elem);
end

%% correct images so sq windows has phase pi/2, as predicted by density matrix treatment
images = images*exp(1i*pi/2);

%% save SQ image for displaying
sq_display=upsampleImage(squeeze(images(1,1,1,:,:)),upsample_factor);

%% fermi filter k-space
if invar.fermi
    display('Fermi Filtering Data');
    k = fftshift(fftshift(fft(fft(fftshift(fftshift(images,4),5),[],4),[],5),4),5);
    [max_row,max_col] = maxRowColIndex(squeeze(k(1,1,1,:,:)));
    
    %filter ZQ
    E=getHOTReconOption('fermi_E');
    T=getHOTReconOption('fermi_T');
    f_surf_norm_zq = makeFermiSurface([size(k,4) size(k,5)],[E E],[T T],[max_row max_col]);
    for echo_number=2:size(k,3)
        k(1,1,echo_number,:,:) = k(1,1,echo_number,:,:).*reshape(f_surf_norm_zq,[1 1 1 size(f_surf_norm_zq)]);
    end
    
    %filter SQ
    f_surf_norm_sq = makeFermiSurface([size(k,4) size(k,5)],[8 8],[2 2],[max_row max_col]);
    k_sq_ref = k(1,1,1,:,:).*reshape(f_surf_norm_sq,[1 1 1 size(f_surf_norm_sq)]); %for taking phase difference between windows

    im = fftshift(fftshift(ifft(ifft(fftshift(fftshift(k,4),5),[],4),[],5),4),5);
    im_sq_ref = fftshift(fftshift(ifft(ifft(fftshift(fftshift(k_sq_ref,4),5),[],4),[],5),4),5);
    images = im;
    clear im
end

images = upsampleImage(images,upsample_factor);
im_sq_ref = upsampleImage(im_sq_ref,upsample_factor);

%% phase the iZQC images to the closest SQC echo
%the following correctly phases alternating echoes in the image domain
pd = zeros(size(images,1),size(images,2),size(images,3)-1,size(images,4),size(images,5));
for timepoint = 1:size(k,1)
    for delay_num=1:size(k,2)
        for zq_echo_num=1:size(pd,3)
            %conversion
            if mod(zq_echo_num,2) %is odd iZQC echo?
                %conversion
                pd_2m=images(timepoint,delay_num,zq_echo_num+1,:,:).*exp(-1i*angle(images(timepoint,delay_num,1,:,:)))*exp(1i*pi/2);
                pd(timepoint,delay_num,zq_echo_num,:,:) = conj(pd_2m)*exp(-1i*pi); %convert from case 2m to -2n
            else
                %conversion
                pd_2m=conj(images(timepoint,delay_num,zq_echo_num+1,:,:).*exp(-1i*angle(images(timepoint,delay_num,1,:,:)))*exp(-1i*pi/2));
                pd(timepoint,delay_num,zq_echo_num,:,:) = conj(pd_2m)*exp(-1i*pi);
            end
        end
    end
end

%% sum pd images
max_echo=getHOTReconOption('num_echoes_avg');
if (max_echo>size(pd,3))
    error('''number of echoes to average'' is too high.  Open HOTReconOptions to change ');
end

if strfind(path,'RMD333')
    echoes_to_avg = scanSpecificAdjustment(0,2);
elseif strfind(path,'RMD332')
    echoes_to_avg = scanSpecificAdjustment(0,3);
elseif strfind(path,'RMD334')
    echoes_to_avg = scanSpecificAdjustment(0,2);    
else
    echoes_to_avg = 1:max_echo;
end

pd_ave=sum(pd(:,:,echoes_to_avg(1:min([max_echo size(echoes_to_avg,2)])),:,:),3);

%% Calculate temperature
t_ave = imagesToTempNT_PD(angle(pd_ave),path,'scanner','GE');
t = imagesToTempNT_PD(angle(pd),path,'scanner','GE');

%% give output
out=struct('i',images,'k',k,'pd',pd,'pd_ave',pd_ave,'t',t,'t_ave',t_ave,'sq',sq_display,'raw',raw);