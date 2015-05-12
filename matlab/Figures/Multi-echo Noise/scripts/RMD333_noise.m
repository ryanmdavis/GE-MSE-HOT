setHOTReconOption('row_shift',6,'col_shift',-19);
reconstruct('RMD333',9);
R=Rois();
R.loadRois(strcat(hotPath('roi'),'\RMD333_marrow_noise.roi'));
mask_333=R.getMasks;
time=[1740 1743 1745 1747 1750];
sq=RMD333_HOT9_1740.sq;
pd=squeeze(RMD333_HOT9_1740.pd(1,1,1,:,:));
pd_ave=squeeze(RMD333_HOT9_1740.pd_ave(1,1,1,:,:));

t=zeros(5,128,128);
t_avg=zeros(5,128,128);
for tp=1:size(time,2)
    t_this=evalin('base',strcat('RMD333_HOT9_',num2str(time(tp)),'.t'));
    t(tp,:,:)=reshape(t_this(1,1,1,:,:),1,128,128);
    t_ave_this=evalin('base',strcat('RMD333_HOT9_',num2str(time(tp)),'.t_ave'));
    t_ave(tp,:,:)=reshape(t_ave_this(1,1,1,:,:),1,128,128);
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

figure,
subplot(1,2,1);
imagesc(std_mat,[0 4]);
axis image off
title('SSE T noise');
subplot(1,2,2);
imagesc(std_ave_mat,[0 4]);
axis image off
title('MSE T noise');


figure,
subplot(1,3,1);
imagesc(abs(sq));
R.outlineRois;
axis square
colormap gray
title('Spin Echo');
subplot(1,3,2);
imagesc(abs(pd));
R.outlineRois;
axis square
colormap gray
title('pd');
subplot(1,3,3);
imagesc(abs(pd_ave));
R.outlineRois;
axis square
colormap gray
title('echo average');

niceFigure(gcf);
noise_333=[t_noise_333, t_ave_noise_333];
figure,hist(noise_333,0:0.5:4);
legend('SSE','MSE')