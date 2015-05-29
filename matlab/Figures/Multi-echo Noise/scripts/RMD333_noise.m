setHOTReconOption('row_shift',6,'col_shift',-19);
reconstruct('RMD333',9);
R=Rois();
% R.loadRois(strcat(hotPath('roi'),'\RMD333_marrow_noise.roi'));
% R.loadRois(strcat(hotPath('roi'),'\RMD333_marrow_noise2.roi'));
R.loadRois(strcat(hotPath('roi'),'\RMD333_marrow_noise3.roi'));
mask_333=R.getMasks;
time=[1740 1743 1745 1747 1750];
sq=RMD333_HOT9_1740.sq;

t=zeros(5,128,128);
t_avg=zeros(5,128,128);
for tp=1:size(time,2)
    t_this=evalin('base',strcat('RMD333_HOT9_',num2str(time(tp)),'.t'));
    t(tp,:,:)=reshape(t_this(1,1,1,:,:),1,128,128);
    t_ave_this=evalin('base',strcat('RMD333_HOT9_',num2str(time(tp)),'.t_ave'));
    t_ave(tp,:,:)=reshape(t_ave_this(1,1,1,:,:),1,128,128);
    pd_this=evalin('base',strcat('RMD333_HOT9_',num2str(time(tp)),'.pd'));
    pd(tp,:,:,:)=reshape(pd_this(1,1,:,:,:),1,4,128,128);

end
% clear RMD333_HOT9*

std_mat=zeros(128);
std_ave_mat=zeros(128);
for row=1:128
    for col=1:128
        if mask_333(row,col)
            std_mat(row,col)=std(t(:,row,col));
            std_ave_mat(row,col)=std(t_ave(:,row,col));
        end
    end
end

t_noise_333=std_mat(std_mat>0);
t_ave_noise_333=std_ave_mat(std_ave_mat>0);

%% display T precision overlays
fse=imresize(double(dicomread(cell2str(strcat(hotPath('images'),'\RMD333\E3356\4\E3356S4I13.DCM')))),0.25);
fse_rgb=intensity2RGB(fse,gray);
sse_mat_rgb=intensity2RGB(std_mat,jet,[0 4]);
sse_ave_mat_rgb=intensity2RGB(std_ave_mat,jet,[0 4]);
sse_rgb=superpose2RGB(sse_mat_rgb,fse_rgb,std_mat>0);
mse_rgb=superpose2RGB(sse_ave_mat_rgb,fse_rgb,std_ave_mat>0);

rows=23:128;
cols=1:106;
figure,
subplot(1,2,1);
imagesc(sse_rgb(rows,cols,:),[0 4]);
axis image off
title('SSE T noise');
subplot(1,2,2);
imagesc(mse_rgb(rows,cols,:),[0 4]);
axis image off
title('MSE T noise');
niceFigure(gcf);
publishableTif4(gcf,'C:\Users\Ryan2\Documents\My manuscripts and conference abstracts\warren lab manuscripts\GE MSE-HOT paper\figures\Echo Averaging\precision overlays -r300.tif',[6 3],1);
figure,imagesc(ones(64),[0 4]);
colorbar
niceFigure(gcf);

niceFigure(gcf);
noise_333=[t_noise_333, t_ave_noise_333];
figure,hist(noise_333,0:0.5:4);
legend('SSE','MSE')