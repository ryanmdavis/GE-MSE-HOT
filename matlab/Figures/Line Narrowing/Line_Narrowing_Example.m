setHOTReconOption('display',0)
reconstruct('RMD216',12);
spectrum216=squeeze(upsampleImage(RMD216_HOT12_1410.s,8));

f1_bw=2000;
f2_bw=15600*2;

plot_bw=2000;
figure,display2DSpectrumE(abs(spectrum216),f1_bw,0,plot_bw,f2_bw,0,plot_bw);
colormap gray
xlabel('\nu_2 (Hz)');
ylabel('\nu_1 (Hz)');
caxis([0 4e8]);
axis square
niceFigure(gcf);

publishableTif4(gcf,'C:\Users\Ryan2\Documents\My manuscripts and conference abstracts\warren lab manuscripts\GE MSE-HOT paper\figures\Line Narrowing\spectruum -r300',[4 4],3);