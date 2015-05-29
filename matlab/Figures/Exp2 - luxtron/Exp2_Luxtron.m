%% define relative position of anatomical and temperature image (from dicom headers)
anat_loc=[-43.8828 -43.7728 -12.3952]; %mm
hot_loc=[-49.2656 -26.2656 -13.4]; %mm

dr_mm=hot_loc(1:2)-anat_loc(1:2); %distance between images in mm
dr_vox=round(dr_mm/(120/128)); %fov = 120mm x 120mm;  matrix = 128x128 voxels
setHOTReconOption('row_shift',-dr_vox(1),'col_shift',-dr_vox(2),'fermi_E',8,'fermi_T',1);

%% define timepoints
time1=[1740 1743 1745 1747 1750 1753 1755 1758];
time2=[1800 1802 1805 1807 1809 1812 1814 1817 1819 1821];
time=[time1 time2];
time_plot=[time1 (time2-40)];

%% turn on echo averaging and reconstruct data
setHOTReconOption('num_echoes_avg',4);
reconstruct('RMD333',9);

%% read FSE scan and correct for chemical shift artifact (AP direction)
background=double(dicomread('C:\Users\Ryan2\Documents\Warren Lab Work\GE 3T data\RMD333\E3356\4\E3356S4I13.DCM'));
fw_shift=round((4.7-1.29)*42.675*3/31.0156); %voxels
background=circshift(background,[-fw_shift 0]);

%% load marrow ROI from hard drive
R=Rois();
R.loadRois('C:\Users\Ryan2\Documents\Warren Lab Work\Analysis\HIFU and HOT\RMD333\RMD333_marrow.roi');
mask_marrow=R.getMasks;

%% load temperature maps into convenient form, and subract baseline
t=zeros(18,512,512); %allocate memory
dt=t; %allocate memory
for tp=1:size(time,2)
    t_this=evalin('base',strcat('RMD333_HOT9_',num2str(time(tp)),'.t_ave'));
    t(tp,:,:)=reshape(imresize(squeeze(t_this(1,1,1,:,:)),4,'nearest'),1,512,512);
end
t_baseline=mean(t(1:5,:,:),1);
for tp=1:size(t,1)
    dt(tp,:,:)=t(tp,:,:)-t_baseline; %change in temperature from baseline
end

%% generate a red box to indicate that the US is on
us_on_box=zeros(512,512,3);
us_on_box(140:190,350:400,1)=1;
us_on=[0 0 0 0 0 1 1 1 1 1 0 0 0 0 0 0 0 0];

%% display the overlaid images
figure
disp_col=1:420;
disp_row=91:512;
for tp=1:size(time,2)
    hot_this=squeeze(dt(tp,:,:));
    background_rgb=intensity2RGB(background/max(max(background)),gray);
    temperature_rgb=intensity2RGB(hot_this,hot,[0 20]);
    i_rgb=superpose2RGB(temperature_rgb,background_rgb,mask_marrow);
    if us_on(tp)
        i_rgb=superpose2RGB(us_on_box,i_rgb,squeeze(us_on_box(:,:,1)));
    end
    subplot(3,6,tp);
    imagesc(i_rgb(disp_row,disp_col,:));
    t_h=text(5,49,strcatspace(num2str(time_plot(tp)-time_plot(1)),' min'));
    set(t_h,'color','w');
    axis image off
end
set(gcf,'Name',(strcatspace('T=',num2str(getHOTReconOption('fermi_T')),'  E=',num2str(getHOTReconOption('fermi_E')),'  NEcho=',num2str(getHOTReconOption('num_echoes_avg')))));
publishableTif4(gcf,'C:\Users\Ryan2\Documents\My manuscripts and conference abstracts\warren lab manuscripts\GE MSE-HOT paper\figures\Exp2\T maps -r300.tif',[9 6],3,'format',3);

%% reconstruct Luxtron data
load('C:\Users\Ryan2\Documents\Warren Lab Work\Analysis\HIFU and HOT\RMD333\RMD333-Luxtron data_4-7-2015-63880.mat');
luxtron_start_time_delay=4*60; %started the luxtron 4 minutes after initiation of imaging
luxtron_time=(timestamps_sec-timestamps_sec(1)+luxtron_start_time_delay)/60;
luxtron_temp=temperature_values-mean(temperature_values(1:50));

%% define luxtron voxel and put temperature im memory
luxtron_voxel = [316 230];
hot_temp=dt(:,luxtron_voxel(1),luxtron_voxel(2));
hot_time=time_plot-time_plot(1);

%% rmsd
time_coarse=findClosestTimeSamples(luxtron_time,hot_time);
rmsd_exp2=sqrt(mean((hot_temp-luxtron_temp(time_coarse,1)).^2));

%% display data
figure,plot(luxtron_time,luxtron_temp(:,1),'k');
hold on
scatter(hot_time,hot_temp,'bx');
% title(strcatspace('T=',num2str(getHOTReconOption('fermi_T')),'  E=',num2str(getHOTReconOption('fermi_E')),'  NEcho=',num2str(getHOTReconOption('num_echoes_avg'))));
title('Experiment #2');
xlabel('time (min)')
ylabel('\DeltaT (\circC)');
legend('Fiber.','MRI');
axis square
xlim([0 45]);
niceFigure(gcf);

publishableTif4(gcf,'C:\Users\Ryan2\Documents\My manuscripts and conference abstracts\warren lab manuscripts\GE MSE-HOT paper\figures\Exp2\luxtron -r300.tif',[4 4],3,'format',0);