setHOTReconOption('num_echoes_avg',4);
RMD332_noise;
RMD333_noise;
close all

t_noise=[t_noise_332',t_noise_333'];
t_ave_noise=[t_ave_noise_332',t_ave_noise_333'];

noise=[t_noise;t_ave_noise];
roundn(mean(noise'),-1)
roundn(median(noise'),-1)

bins=0:0.25:4;
figure,hist(noise',bins);
xlim([min(bins) max(bins)]);
xlabel('\sigma_T (\circC)');
ylabel('# of voxels');
legend('SSE','MSE');
axis square
niceFigure(gcf,'format',2);

publishableTif4(gcf,'C:\Users\Ryan2\Documents\My manuscripts and conference abstracts\warren lab manuscripts\GE MSE-HOT paper\figures\Echo Averaging\histogram -r300.tif',[4 4],1,'format',0);