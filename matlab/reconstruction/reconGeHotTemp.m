%reconGeHotTemp2 reconstructs temperature image with the following
%coherence orders - iZQC - SQ - SQ - iZQC ....
function [images,k,t,fields] = reconGeHotTemp(path,varargin)

%optional function arguments
invar = struct('disp',0,'fermi',1,'data_type','image','recon_elem',0,'shift',[0 0],'evolution_time',[]);
argin = varargin;
invar = generateArgin(invar,argin);

%read and fft raw data
raw = readGE2DRaw(path);
% raw=permute(raw,[1 3 2]);
raw = flipdim(raw,4);
images = fftshift(fftshift(ifft(ifft(fftshift(fftshift(raw,4),5),[],4),[],5),4),5);
images = circshift(images,[0 0 0 invar.shift]);
% images(:,:,1,:,:) = flipdim(images(:,:,1,:,:),5); %zero quantum image appears to be flipped

%current recon takes into account the effect of pi pulse on zq phase, so
%don't need this line.  See Lab notebook pgs 178-181 for derivation.
% images(1,:,:,:) = conj(images(1,:,:,:));

%read info about image
fields = struct('Coil_name',[],'rhnecho',[],'xres',[],'yres',[],'variable_46',[],'variable_42',[],'variable_47',[],'Scan_time',[]);
fields = getGeHdrEntry(strcat(path,'_header.txt'),fields);
opxres = fields.xres;
opyres = fields.yres;
if isempty(invar.evolution_time)
    t1 = fields.variable_46/1000; %divide by 1000 converts microseconds to milliseconds
    tau = fields.variable_47/1000;
    time_evolution_ms = t1+tau;
else 
    time_evolution_ms=invar.evolution_time;
end

%assemble phased array data if is a coil array:
if coilName2NumCoils(fields.Coil_name) > 1
    display('Assembling data from the coil elements');
    images = assemblePhasedNMRDataHOT(images,invar.data_type,invar.recon_elem);
end

% assembled_images = assembled_images;%because SE window should be Iy
if invar.fermi
    display('Fermi Filtering Data');
    k = fftshift(fftshift(fft(fft(fftshift(fftshift(images,4),5),[],4),[],5),4),5);
    [max_row,max_col] = maxRowColIndex(squeeze(k(1,1,1,:,:)));
    f_surf_norm = makeFermiSurface([size(k,4) size(k,5)],[3.5 3.5],[1 1],[max_row max_col]);
    k(1,1,1,:,:) = k(1,1,1,:,:).*reshape(f_surf_norm,[1 1 1 size(f_surf_norm)]);
%     k(1,1,2,:,:) = k(1,1,2,:,:).*reshape(f_surf_norm,[1 1 1 size(f_surf_norm)]);

    % k = gaussianFilterKspaceND(k,6,6);
    im = fftshift(fftshift(ifft(ifft(fftshift(fftshift(k,4),5),[],4),[],5),4),5);
%     images(1,1,1,:,:) = im(1,1,1,:,:);
    images = im;
    clear im
end

images = upsampleImage(images,4);
% [max_row,max_col] = maxRowColIndex(squeeze(abs(images(1,:,:))));
% snr =  abs(images(1,max_row,max_col))/std(abs(images(1,:,2)));

if invar.disp
   figure,subplot(2,2,1)
   imagesc(abs(squeeze(images(1,1,1,:,:))))
   axis square off
   title('Window 1 - magnitude','FontSize',15);
   
   subplot(2,2,2)
   imagesc(angle(squeeze(images(1,1,1,:,:))))
   axis square off
   title('Window 1 - phase','FontSize',15);
   
   subplot(2,2,3)
   imagesc(abs(squeeze(images(1,1,2,:,:))))
   axis square off
   title('Window 2 - magnitude','FontSize',15);
   
   subplot(2,2,4)
   imagesc(angle(squeeze(images(1,1,2,:,:))))
   axis square off
   title('Window 2 - phase','FontSize',15);
end

if invar.disp
   figure,subplot(2,2,1)
   imagesc(abs(squeeze(k(1,1,1,:,:))))
   axis square off
   title('Window 1 - magnitude','FontSize',15);
   
   subplot(2,2,2)
   imagesc(angle(squeeze(k(1,1,1,:,:))))
   axis square off
   title('Window 1 - phase','FontSize',15);
   
   subplot(2,2,3)
   imagesc(abs(squeeze(k(1,1,2,:,:))))
   axis square off
   title('Window 2 - magnitude','FontSize',15);
   
   subplot(2,2,4)
   imagesc(angle(squeeze(k(1,1,2,:,:))))
   axis square off
   title('Window 2 - phase','FontSize',15);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display images and snr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if invar.disp
    figure,imagesc(squeeze(abs(images(1,1,1,:,:))));
    t_h = text(50,200,strcat('SNR = ',num2str(roundn(snr,1))),'color',[1 1 1],'FontSize',20);
    colormap gray

    figure,imagesc(squeeze(angle(images(1,1,1,:,:))));
    colorbar
    colormap hsv
    title('Image phase','FontSize',15);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate temperature
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~fields.variable_42
    t = imagesToTempNT(images,time_evolution_ms,'field_strength_T',3);
end

if invar.disp
    foreground_threshold = 3;
    foreground_map = squeeze(abs(images(1,1,1,:,:))) > max(max(abs(squeeze(images(1,1,1,:,:)))))/foreground_threshold;
    range_max = max(max(t(foreground_map)));
    range_min = min(min(t(foreground_map)));
    t_rgb = imageToBlackBackgroundB(t,foreground_map,[range_min range_max],hot);
    figure,subplot(1,2,1),imagesc(t_rgb)
    axis square off
    subplot(1,2,2),imagesc(ones(10,1),[range_min range_max]);
    axis image off
    colorbar
    colormap hot
end