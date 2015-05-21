%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header

%% pulse sequence parameters
psd_dur=58000;

%% line sizes
bold=2.5;
thin=1;

%% space between channels
separation=2.3;
rf_off=1.5;
echo_off=0.9;
gz_off=rf_off-1*separation;
gx_off=rf_off-2*separation;
gy_off=rf_off-3*separation;

rf=zeros(psd_dur,1);
gz=zeros(psd_dur,1);
gx=zeros(psd_dur,1);
gy=zeros(psd_dur,9);

gz_crush=zeros(psd_dur,1);
gx_crush=zeros(psd_dur,2);
gy_crush=zeros(psd_dur,2);
gz_crush2=zeros(psd_dur,1);
gx_crush2=zeros(psd_dur,2);
gy_crush2=zeros(psd_dur,2);

shift=3000;
gauss=@(s,x)exp(-x.^2/(sqrt(2)*s^2));

echo_period=800;

figure
set(gca,'Xlim',[0 psd_dur]);
set(gca,'Ylim',[-8 1.5]);
hold on
%hard excitation pulse
rf((1001:2000)+shift)=1;
centeredTextOnPlot(1501+shift,rf_off,'90^\circ');

%first correlation gradient
gz((2801:4200)+shift)=trap(1400,300);
centeredTextOnPlot(3001+shift,gz_off,'mGT');

%selective 180
rf((5001:8000)+shift)=gauss(600,-1500:1499);
centeredTextOnPlot(6501+shift,rf_off,'180^\circ_f');

%second correlation gradient
gz((8801:10200)+shift)=trap(1400,300);
centeredTextOnPlot(9500+shift,gz_off,'nGT');

%selective 90
rf((11001:14000)+shift)=gauss(600,-1500:1499);
centeredTextOnPlot(12501+shift,rf_off,'90^\circ_w');

%slice selective sinc pulse
rf2_pos=17001;
rf(rf2_pos+(1:3000)+shift)=sinc((-1500:1499)*pi/2500);
centeredTextOnPlot(rf2_pos+1500+shift,rf_off,'180^\circ');

%slice selection gradients
gz(rf2_pos+(-1000:-1)+shift,1)=trap(1000,200);
gz(rf2_pos+(3000:3999)+shift,1)=trap(1000,200);
gz((rf2_pos-51:rf2_pos+3049)+shift,1)=0.2;
gz_crush(rf2_pos+(-1000:-1)+shift,1)=trap(1000,200);
gz_crush(rf2_pos+(3000:3999)+shift,1)=trap(1000,200);
gz_crush(rf2_pos+(-51:3049)+shift,1)=0.2;

%third correlation gradient
cg3_pos=25000;
gz(linspace(cg3_pos-700,cg3_pos+700,1401)+shift)=trap(1401,300);
centeredTextOnPlot(cg3_pos+shift+2000,gz_off-2,'(n-m)GT');

%first echo
rf((27501:31500)+shift)=gauss(800,-2000:1999).*cos(2*pi*(-2000:1999)/echo_period)*0.5;
centeredTextOnPlot(29501+shift,echo_off,'SQC');


%read encoding first echo
gx((26501:27500)+shift)=-trap(1000,200);
gx((31501:32500)+shift)=-trap(1000,200);
gx((27501:31500)+shift)=0.25*trap(4000,100);

%phase encoding first echo
for ii=4:-1:-4
    gy((26501:27500)+shift,5-ii)=trap(1000,200)*ii/4;
end
gy((31501:32500)+shift,:)=-gy((26501:27500)+shift,:);

%fourth correlation gradient
gz((32501:33900)+shift)=trap(1400,300);
centeredTextOnPlot(33501+shift+1000,gz_off,'(m+n)GT');

%second echo
echo2_pos=37501;
rf(linspace(echo2_pos-1999,echo2_pos+2000,4000)+shift)=gauss(800,-2000:1999).*cos(2*pi*(-2000:1999)/echo_period)*0.5;
centeredTextOnPlot(echo2_pos+shift,echo_off,'iZQC');

%read encoding second echo
gx((34501:35500)+shift)=-trap(1000,200);
gx((39501:40500)+shift)=-trap(1000,200);
gx((35501:39500)+shift)=0.25*trap(4000,100);

%phase encoding second echo
for ii=4:-1:-4
    gy((34501:35500)+shift,5-ii)=trap(1000,200)*ii/4;
end
gy((39501:40500)+shift,:)=-gy((34501:35500)+shift,:);

%2nd slice selective sinc pulse
rf22_pos=44501;
rf((rf22_pos-1499:rf22_pos+1500)+shift)=sinc((-1500:1499)*pi/2500);

%2nd slice selection gradients
gz((rf22_pos-2499:rf22_pos-1500)+shift)=-trap(1000,200);
gz((rf22_pos+1501:rf22_pos+2500)+shift)=-trap(1000,200);
gz((rf22_pos-1549:rf22_pos+1550)+shift)=0.2;
gx_crush2((rf22_pos-2499:rf22_pos-1500)+shift,1)=trap(1000,200);
gx_crush2((rf22_pos+1501:rf22_pos+2500)+shift,1)=trap(1000,200);
gx_crush2((rf22_pos-2499:rf22_pos-1500)+shift,2)=-trap(1000,200);
gx_crush2((rf22_pos+1501:rf22_pos+2500)+shift,2)=-trap(1000,200);

%third echo
echo3_pos=rf22_pos+rf22_pos-echo2_pos;
rf((echo3_pos-1999:echo3_pos+2000)+shift)=gauss(800,-2000:1999).*cos(2*pi*(-2000:1999)/echo_period)*0.5;
centeredTextOnPlot(echo3_pos+shift,echo_off,'iZQC');

%read encoding third echo
gx((echo3_pos-2999:echo3_pos-2000)+shift)=-trap(1000,200);
gx((echo3_pos+2001:echo3_pos+3000)+shift)=-trap(1000,200);
gx((echo3_pos-1999:echo3_pos+2000)+shift)=0.25*trap(4000,100);

%phase encoding third echo
for ii=4:-1:-4
    gy((46501:47500)+shift,5-ii)=trap(1000,200)*ii/4;
end
gy((51501:52500)+shift,:)=-gy((46501:47500)+shift,:);

%label channels
channel_offset=0.7;
text(0,channel_offset,'RF');
text(0,channel_offset-1*separation,'Gz');
text(0,channel_offset-2*separation,'Gx');
text(0,channel_offset-3*separation,'Gy');


gz=gz-separation;
gx=gx-2*separation;
gy=gy-3*separation;
gz_crush=gz_crush-1*separation;
gx_crush=gx_crush-2*separation;
gy_crush=gy_crush-3*separation;
gz_crush2=gz_crush2-1*separation;
gx_crush2=gx_crush2-2*separation;
gy_crush2=gy_crush2-3*separation;


plot(rf,'k','LineWidth',bold);
set(gcf,'Position',[213 226 1269 359]);
axis off
hold on
plot(gz(:,1),'k','LineWidth',bold);
plot(gx(:,1),'k','LineWidth',bold);
plot(gy(:,1),'k','LineWidth',bold);
plot(gy(:,2:end),'k','LineWidth',thin);
crush_range=(rf2_pos-1000:rf2_pos+4000)+shift;
crush_range2=(rf22_pos-2500:rf22_pos+2500)+shift;
plot(crush_range,gz_crush(crush_range,:),'k','LineWidth',thin);
plot(crush_range,gx_crush(crush_range,:),'k','LineWidth',thin);
plot(crush_range2,gx_crush2(crush_range2,:),'k','LineWidth',thin);
set(findobj(gca,'Type','text'),'FontName','Arial');
set(findobj(gca,'Type','text'),'FontSize',18);

%% write to file
% publishableTif4(gcf,'C:\Users\Ryan2\Documents\My manuscripts and conference abstracts\warren lab manuscripts\GE MSE-HOT paper\figures\MSE-HOT on GE\MSE-HOT on GE.tif',[10 2],0,'format',0);