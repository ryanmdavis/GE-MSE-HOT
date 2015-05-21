setHOTReconOption('display',0);
hot=reconGeHotTemp2(strcat(cell2str(hotPath('images')),'\RMD332\P30720.7_04031503'));
zq_ce4=upsampleImage(squeeze(hot.raw(1,4,3,:,:)),4);
zq_ce5=upsampleImage(squeeze(hot.raw(1,5,3,:,:)),4);
sq_ce4=upsampleImage(squeeze(hot.raw(1,4,1,:,:)),4);
sq_ce5=upsampleImage(squeeze(hot.raw(1,5,1,:,:)),4);

pd_ce4=zq_ce4.*conj(sq_ce4);
pd_ce5=zq_ce5.*conj(sq_ce5);

sum_pd=pd_ce4+pd_ce5;

disp_rows=65:110;
disp_cols=45:90;

figure
subplot(5,4,1);
imagesc(abs(zq_ce4(disp_rows,disp_cols)));
t_h(1)=text(1,40,'z_{n,1}(x,y)');
axis image off
subplot(5,4,2);
imagesc(abs(sq_ce4(disp_rows,disp_cols)));
t_h(2)=text(1,40,'s_{1,1}(x,y)');
axis image off
subplot(5,4,3);
imagesc(abs(zq_ce5(disp_rows,disp_cols)));
axis image off
t_h(3)=text(1,40,'z_{n,2}(x,y)');
subplot(5,4,4);
imagesc(abs(sq_ce5(disp_rows,disp_cols)));
axis image off
t_h(4)=text(1,40,'s_{1,2}(x,y)');
subplot(5,4,[5,6,9,10]);
imagesc(abs(pd_ce4(disp_rows,disp_cols)),[0 1.5e10]);
axis image off
t_h(5)=text(1,43,'d_{n,1}(x,y)=z_{n,1}(x,y)*s^*_{1,1}(x,y)');
subplot(5,4,[7,8,11,12]);
imagesc(abs(pd_ce5(disp_rows,disp_cols)),[0 1.5e10]);
axis image off
t_h(6)=text(1,43,'d_{n,2}(x,y)=z_{n,2}(x,y)*s^*_{1,2}(x,y)');
subplot(5,4,[14,15,18,19]);
imagesc(abs(sum_pd(disp_rows,disp_cols)),[0 1.5e10]);
axis image off
t_h(7)=text(1,43,'d_n(x,y)=d_{n,1}(x,y)+d_{n,2}(x,y)');
colormap gray

set(t_h,'Interpreter','tex','Color','w');
niceFigure(gcf,'publishable',1,'fs_adjust',1.1);

% set(gcf,'Position',[520 87 560 711]);
publishableTif4(gcf,'C:\Users\Ryan2\Documents\My manuscripts and conference abstracts\warren lab manuscripts\GE MSE-HOT paper\figures\recon example\images.tif',[4 5],1,'format',0);