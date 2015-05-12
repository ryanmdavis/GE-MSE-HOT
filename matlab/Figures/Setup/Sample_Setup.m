%% read FSE scan and correct for chemical shift artifact (AP direction)
background=double(dicomread(char(strcat(hotPath('images'),'\RMD333\E3356\4\E3356S4I13.DCM'))));
fw_shift=round((4.7-1.29)*42.675*3/31.0156); %voxels
background=circshift(background,[-fw_shift 0]);

display_voxels=[82:512;1:431];
figure
imagesc(background(display_voxels(1,:),display_voxels(2,:)));
axis image off
colormap gray
publishableTif4(gcf,'C:\Users\Ryan2\Documents\My manuscripts and conference abstracts\warren lab manuscripts\GE MSE-HOT paper\figures\Sample Setup\Sample Setup -r300.tif',[4 4],3)