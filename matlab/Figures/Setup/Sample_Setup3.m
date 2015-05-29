%% load images to memory
axial=double(dicomread(char(strcat(hotPath('images'),'\RMD333\E3356\4\E3356S4I13.DCM'))));
saggital=imrotate(double(dicomread(char(strcat(hotPath('images'),'\RMD333\E3356\3\E3356S3I11.DCM')))),270);

%% define rows and columns to display
rows=60:512;
cols=1:420;

figure
subplot(1,2,1)
imagesc(abs(axial(rows,cols)));
axis square off
subplot(1,2,2);
imagesc(abs(saggital(rows,cols)));
axis square off
colormap gray