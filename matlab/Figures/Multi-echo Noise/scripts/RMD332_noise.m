setHOTReconOption('row_shift',0,'col_shift',0);
reconstruct('RMD332',7);
R=Rois();
R.loadRois(strcat(hotPath('roi'),'\RMD332_marrow.roi'));
mask_332=R.getMasks;

time=[1500 1504 1506 1509 1511];
t=zeros(size(time,2),128,128);
t_ave=t;

for tp=1:5
    t_this=evalin('base',strcat('RMD332_HOT7_',num2str(time(tp)),'.t'));
    t(tp,:,:)=reshape(t_this(1,1,1,:,:),1,128,128);
    t_ave_this=evalin('base',strcat('RMD332_HOT7_',num2str(time(tp)),'.t_ave'));
    t_ave(tp,:,:)=reshape(t_ave_this(1,1,1,:,:),1,128,128);
end
clear RMD332_HOT7*

std_mat=zeros(128);
std_ave_mat=zeros(128);
for row=1:128
    for col=1:128
        if mask_332(row,col)
            std_mat(row,col)=std(t(:,row,col));
            std_ave_mat(row,col)=std(t_ave(:,row,col));
        end
    end
end

t_noise_332=std_mat(std_mat>0);
t_ave_noise_332=std_ave_mat(std_ave_mat>0);

figure,
subplot(1,2,1);
imagesc(std_mat,[0 4]);
axis image off
title('SSE T noise');
subplot(1,2,2);
imagesc(std_ave_mat,[0 4]);
axis image off
title('MSE T noise');

noise_332=[t_noise_332,t_ave_noise_332];
figure,hist(noise_332)
xlabel('\sigma_T');
ylabel('number of voxels');
legend('SSE','MSE');