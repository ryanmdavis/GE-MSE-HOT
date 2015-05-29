%% reconstruct MRI data
setHOTReconOption('num_echoes_avg',1,'row_shift',0,'col_shift',0);
reconstruct('RMD332',7);

%% define timepoints
time=[1500 1504 1506 1509 1511 1513 1516 1518 1520 1523 1525 1527 1530 1532 1534 1537 1539 1542];
us_on=[0 0 0 0 0 1 1 1 1 1 0 0 0 0 0 0 0 0];

%% allocate memory
t=zeros(size(time,2),128,128);
im=zeros(size(time,2),5,128,128);
t_range=[10 40];
dt_range=[0 20];

%% define voxels to display as foreground in images
mask=squeeze(abs(RMD332_HOT7_1500.sq))>0.25*max(max(squeeze(abs(RMD332_HOT7_1500.sq))));

%% define which voxels to display
col=40:90;
row=65:115;

%% put all of the data into 3D arrays -> time x row x col
for tp=1:size(time,2)
    t_this=evalin('base',strcat('RMD332_HOT7_',num2str(time(tp)),'.t_ave'));
    t(tp,:,:)=reshape(t_this(1,1,1,:,:),1,128,128);
    im_this=evalin('base',strcat('RMD332_HOT7_',num2str(time(tp)),'.i'));
    im(tp,:,:,:)=reshape(im_this(1,1,:,:,:),1,5,128,128);
end

%% calculate delta T
t_baseline=mean(t(1:5,:,:),1);
dt=zeros(size(t));
for tp=1:size(t,1)
    dt(tp,:,:)=t(tp,:,:)-t_baseline;
end

%% show delta temperature, put red square if heat is on
us_on_square=zeros(size(row,2),size(col,2),3);
figure
for tp=1:size(time,2)
    if us_on(tp) 
        us_on_square(5:10,44:49,1)=1;
        us_on_square(5:10,44:49,2:3)=0;
    else us_on_square(5:10,44:49,:)=0.5;
    end
    t_rgb_=intensity2RGB(squeeze(dt(tp,row,col)),hot,dt_range);    
    t_rgb=superpose2RGB(t_rgb_,0.5*ones(size(row,2),size(col,2),3),mask(row,col));
    t_rgb=superpose2RGB(t_rgb,us_on_square,~squeeze(us_on_square(:,:,1)));
    subplot(3,6,tp);
    imagesc(t_rgb);
    text(3,44,strcatspace(num2str(time(tp)-time(1)),' min'));
    axis image off
end
% niceFigure(gcf);
% set(gcf,'Position',[208 149 872 649]);
publishableTif4(gcf,'C:\Users\Ryan2\Documents\My manuscripts and conference abstracts\warren lab manuscripts\GE MSE-HOT paper\figures\Exp1\temperature maps.tif',1*[5 4],3);

%% show temperature maps
figure
for tp=1:size(time,2)
    hot_this=squeeze(dt(tp,:,:));
    subplot(3,6,tp);
    imagesc(hot_this);
    title(strcatspace(num2str(time(tp)-time(1)),' min'));
    axis image off
end
%  
%% select which voxel is plotted
voxel_5mm=[78 67];
voxel_10mm=[82 67];
voxel_15mm=[86 67];
voxel_air=[20 20];
voxel_use=[81 68];

%% reconstruct Luxtron data
load('C:\Users\Ryan2\Documents\Warren Lab Work\Analysis\HIFU and HOT\RMD332\RMD332-Luxtron data_4-3-2015-54405.mat');
luxtron_start_time_delay=320; %started the luxtron 320s after initiation of imaging
luxtron_time=(timestamps_sec-timestamps_sec(1)+luxtron_start_time_delay)/60;

t_delta=t(:,voxel_use(1),voxel_use(2))-mean(t(1:5,voxel_use(1),voxel_use(2)));
lux_delta=temperature_values(:,1)-temperature_values(1,1);

%% rmsd
hot_time=time-time(1);
time_coarse=findClosestTimeSamples(luxtron_time,hot_time);
rmsd_exp1=sqrt(mean((t_delta-lux_delta(time_coarse,1)).^2));

f_mvl=figure;
scatter(time-time(1),t_delta,'bx');
hold on
plot(luxtron_time,lux_delta,'k')
% legend('MRI','Luxtron');
xlabel('time (min)');
ylim([-5 15]);
ylabel('\DeltaT (\circC)');
axis square
xlim([0 45]);
% niceFigure(gcf);
publishableTif4(f_mvl,'C:\Users\Ryan2\Documents\My manuscripts and conference abstracts\warren lab manuscripts\GE MSE-HOT paper\figures\Exp1\MRI vs Luxtron.tif',[1.5 1.5],1);

%% show spin echo and iZQC images
figure
subplot(2,2,1);
imagesc(squeeze(abs(RMD332_HOT7_1500.i(1,1,1,row,col))));
axis image off
subplot(2,2,3);
imagesc(squeeze(abs(RMD332_HOT7_1500.i(1,1,2,row,col))));
axis image off
subplot(2,2,4);
axis image off
colormap gray
publishableTif4(gcf,'C:\Users\Ryan2\Documents\My manuscripts and conference abstracts\warren lab manuscripts\GE MSE-HOT paper\figures\Exp1\magnitude images.tif',[4 4],1);