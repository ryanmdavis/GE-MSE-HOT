%% define relative position of FSE and HOT image (from dicom headers)
FSE_loc=[-43.8828 -43.7728 -12.3952]; %mm
hot_loc=[-49.2656 -26.2656 -13.4]; %mm

dr_mm=hot_loc(1:2)-FSE_loc(1:2); %distance between images in mm
recon_size=512;
dr_vox=round(dr_mm/(120/recon_size)); %fov = 120mm x 120mm;  matrix = 128x128 voxels
setHOTReconOption('row_shift',-dr_vox(1),'col_shift',-dr_vox(2),'recon_size',recon_size,'fermi_E',6,'fermi_T',1,'weight_iZQC',0);
hot_s=getDirScanInfo_reconImagePfile(char(strcat(hotPath('images'),'\RMD333\P54784.7_04071743')));
setHOTReconOption('weight_iZQC',1);
hot_weighted_s=getDirScanInfo_reconImagePfile(char(strcat(hotPath('images'),'\RMD333\P54784.7_04071743')));
setHOTReconOption('row_shift',0,'col_shift',0,'recon_size',128);


%% read FSE scan and correct for chemical shift artifact (AP direction)
background=double(dicomread(char(strcat(hotPath('images'),'\RMD333\E3356\4\E3356S4I13.DCM'))));
fw_shift=round((4.7-1.29)*42.675*3/31.0156); %voxels
background=circshift(background,[-fw_shift 0]);

display_voxels=[82:512;1:431];
figure
subplot(2,3,1);
imagesc(background(display_voxels(1,:),display_voxels(2,:)));
axis image off
subplot(2,3,2);
imagesc(abs(hot_s.sq(display_voxels(1,:),display_voxels(2,:))));
axis image off
subplot(2,3,4);
imagesc(abs(squeeze(hot_s.pd(1,1,1,display_voxels(1,:),display_voxels(2,:)))));
axis image off
subplot(2,3,5);
imagesc(abs(squeeze(hot_weighted_s.pd(1,1,1,display_voxels(1,:),display_voxels(2,:)))));
axis image off
colormap gray

publishableTif4(gcf,'C:\Users\Ryan2\Documents\My manuscripts and conference abstracts\warren lab manuscripts\GE MSE-HOT paper\figures\Sample Setup\Sample Setup -r300.tif',[9 6],3)