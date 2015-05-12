setHOTReconOption('display',0,'row_shift',0,'col_shift',0);
hot_333=getDirScanInfo_reconImagePfile(char(strcat(hotPath('images'),'\RMD333\P54784.7_04071743')));

display_voxels=[43:116;38:111];
iZQC_scale=max(max(max(abs(squeeze(hot_333.pd(1,1,:,display_voxels(1,:),display_voxels(2,:)))))));
f_images=figure
subplot(2,3,1)
imagesc(abs(squeeze(hot_333.sq(display_voxels(1,:),display_voxels(2,:)))));
axis image off
subplot(2,3,2)
imagesc(abs(squeeze(hot_333.pd(1,1,1,display_voxels(1,:),display_voxels(2,:)))),[0 iZQC_scale]);
axis image off
subplot(2,3,3)
imagesc(abs(squeeze(hot_333.pd(1,1,2,display_voxels(1,:),display_voxels(2,:)))),[0 iZQC_scale]);
axis image off
subplot(2,3,4)
imagesc(abs(squeeze(hot_333.pd(1,1,3,display_voxels(1,:),display_voxels(2,:)))),[0 iZQC_scale]);
axis image off
subplot(2,3,5)
imagesc(abs(squeeze(hot_333.pd(1,1,4,display_voxels(1,:),display_voxels(2,:)))),[0 iZQC_scale]);
axis image off
subplot(2,3,6)
imagesc(abs(squeeze(hot_333.pd_ave(1,1,1,display_voxels(1,:),display_voxels(2,:)))),[0 iZQC_scale*3]);
axis image off

colormap gray

publishableTif4(f_images,'C:\Users\Ryan2\Documents\My manuscripts and conference abstracts\warren lab manuscripts\GE MSE-HOT paper\figures\Echo Averaging\images -r300.tif',[6 4],3);