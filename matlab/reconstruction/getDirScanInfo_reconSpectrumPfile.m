%% main function
function out = getDirScanInfo_reconSpectrumPfile(directory)

fields = struct('variable_37',0);
fields = getGeHdrEntry(strcat(directory,'_header.txt'),fields);

if fields.variable_37 == 2
    out=recon2(directory);
else
    out=recon1(directory);
end
end


%% ZQSQ2
function out = recon1(directory)
[s,~,td]=reconGeHotSpectra(directory);
out=struct('s',s,'td',td,'max_zq_points',[]);

if getHOTReconOption('display')
    %read scan parameters from header
    fields = struct('yres',[],'variable_47',[],'variable_42',0,'variable_48',0,'variable_40',0,'variable_41',0,'variable_37',0,'Last_series_number_used',0);
    fields = getGeHdrEntry(strcat(directory,'_header.txt'),fields);

    spect_flag=fields.variable_42;
    tau=fields.variable_47;
    tau_max=fields.variable_48;
    opyres=fields.yres;
    oprbw=fields.variable_40;
    oprbw2=fields.variable_41;
    f1_bw=1e6/((tau_max-tau)/opyres);

    %% display the spectra
    exp_name = expName(directory);
    figure
    set(gcf,'name',cell2str(strcat({exp_name},{': Scan #'},{num2str(fields.Last_series_number_used)})));
    set(gcf,'position',[191 104 889 694]);
    if size(s,3)>1
        subplot_size_col=ceil(log2(size(s,3)));
        subplot_size_row=ceil(size(s,3)/subplot_size_col);
    else
        subplot_size_col=1;
        subplot_size_row=1;
    end
    [zq_windows,~] = zqsqCoherenceOrder(size(s,3),2);
    sq_phase_vect=zeros(1,ceil(size(s,3)/2));
    echo_num_sq=1;
    [~,max_coil]=max(squeeze((max(max(abs(s(1,:,zq_windows(1),:,:)),[],4),[],5))));
    out.max_coil=max_coil;
    for echo_num=1:size(s,3);
        subplot(subplot_size_row,subplot_size_col,echo_num);
        display2DSpectrumD(abs(squeeze(s(1,max_coil,echo_num,:,:))),f1_bw,0,f1_bw,oprbw,0,f1_bw);
        axis square
        if sum(zq_windows==echo_num)
            title(cell2str(strcat({'echo number: '},{num2str(echo_num)},{' - iZQC'})));
        else
            title(cell2str(strcat({'echo number: '},{num2str(echo_num)},{' - SQC'})));
            [r,c]=maxRowColIndex(squeeze(abs(squeeze(s(1,max_coil,echo_num,:,:)))));
            sq_phase_vect(echo_num_sq)=angle(squeeze(s(1,max_coil,echo_num,r,c)));
            echo_num_sq=echo_num_sq+1;
        end
        xlabel('\nu_2 (Hz)');
        ylabel('\nu_1 (Hz)');
    end

    %% write snr
    signal=max(max(abs(squeeze(s(1,max_coil,1,:,:)))));
    noise=std(reshape(real(squeeze(s(1,max_coil,1,(end-10):end,(end-10):end))),1,121));
    snr_str=round(num2str(signal/noise));
    display(cell2str(strcat({exp_name},{': Scan #'},{num2str(fields.Last_series_number_used)},{': iZQC SNR was: '},{snr_str})));

    %% display the zq peak size
    % max_zq_points=zeros(1,size(s,3)/2);
    % max_zq_phase=zeros(1,size(s,3)/2);
    % max_sq_phase=zeros(1,size(s,3)/2);
    % max_sq_mag=max_sq_phase;
    % max_ct=1;
    % for echo_num=1:size(s,3);
    %     if sum(echo_num==zq_windows)
    %         max_zq_points(max_ct)=max(max(abs(squeeze(s(1,max_coil,echo_num,:,:)))));
    %         [r,c]=maxRowColIndex(squeeze(s(1,max_coil,echo_num,:,:)));
    %         max_zq_phase(max_ct)= angle(s(1,max_coil,echo_num,r,c));
    %     else
    %         [r,c]=maxRowColIndex(squeeze(s(1,max_coil,echo_num,:,:)));
    %         max_sq_phase(max_ct)= angle(s(1,max_coil,echo_num,r,c));
    %         max_sq_mag(max_ct)= abs(s(1,max_coil,echo_num,r,c));
    %     end
    %     if ~mod(echo_num,2)
    %         max_ct=max_ct+1;
    %     end
    % end

    %% display 1D projection of first echo
    hz=linspace(-0.5*f1_bw,0.5*f1_bw,size(s,4));
    [~,c]=maxRowColIndex(abs(squeeze(s(1,max_coil,zq_windows(1),:,:))));
    f1_spect=abs(squeeze(s(1,max_coil,1,:,c)));
    figure,plot(hz,f1_spect/max(f1_spect));
    axis square
    xlabel('resonance frequency (Hz)');
    ylabel('signal intensity (a.u.)');
    title('indirectly detected evolution');
    niceFigure(gcf);
end
end



%% ZQSQ3
function out = recon2(directory)

[s,~,td]=reconGeHotSpectra(directory);
out=struct('s',s,'td',td,'max_zq_points',[]);
%read scan parameters from header
fields = struct('yres',[],'variable_47',[],'variable_42',0,'variable_48',0,'variable_40',0,'variable_41',0,'variable_37',0,'Last_series_number_used',0);
fields = getGeHdrEntry(strcat(directory,'_header.txt'),fields);

%calculate spectra parameters
f1_bw=fields.yres/(1e-6*(fields.variable_48-fields.variable_47));
oprbw=fields.variable_40;

%display the zq peak size
max_zq_points=zeros(1,size(s,3)-1);
max_zq_phase=zeros(1,size(s,3)-1);
max_sq_phase=zeros(1,size(s,3)-1);
max_sq_mag=max_sq_phase;
max_ct=1;

[~,max_coil]=max(squeeze((max(max(abs(s(1,:,2,:,:)),[],4),[],5))));
for echo_num=1:size(s,3);
    if echo_num>=2
        max_zq_points(max_ct)=max(max(abs(squeeze(s(1,max_coil,echo_num,:,:)))));
        [r,c]=maxRowColIndex(squeeze(s(1,max_coil,echo_num,:,:)));
        max_zq_phase(max_ct)= angle(s(1,max_coil,echo_num,r,c));
    else
        [r,c]=maxRowColIndex(squeeze(s(1,max_coil,echo_num,:,:)));
        max_sq_phase(max_ct)= angle(s(1,max_coil,echo_num,r,c));
        max_sq_mag(max_ct)= abs(s(1,max_coil,echo_num,r,c));
    end
    max_ct=max_ct+1;
end

%% display the spectra
figure
exp_name = expName(directory);
set(gcf,'name',cell2str(strcat({exp_name},{' Scan #'},{num2str(fields.Last_series_number_used)})));
set(gcf,'position',[191 104 889 694]);
subplot_size_col=ceil(log2(size(s,3)));
subplot_size_row=ceil(size(s,3)/subplot_size_col);
echo_num_sq=1;
for echo_num=1:size(s,3);
    subplot(subplot_size_row,subplot_size_col,echo_num);
    display2DSpectrumD(abs(squeeze(s(1,max_coil,echo_num,:,:))),f1_bw,0,f1_bw,2*oprbw,0,2*oprbw);
    axis square
    if echo_num==1
        title(cell2str(strcat({'echo number: '},{num2str(echo_num)},{' - SQC'})));
    else
        title(cell2str(strcat({'echo number: '},{num2str(echo_num)},{' - iZQC'})));
        [r,c]=maxRowColIndex(squeeze(abs(squeeze(s(1,max_coil,echo_num,:,:)))));
        echo_num_sq=echo_num_sq+1;
    end
    xlabel('\nu_2 (Hz)');
    ylabel('\nu_1 (Hz)');
end

%% display ZQ echo intensity
out.max_zq_points=max_zq_points;
figure,subplot(1,2,1),plot(max_zq_points(2:end));
hold on
% plot(max_sq_mag);
xlabel('ZQ echo number');
ylabel('signal intensity');
axis square
legend('iZQC');

subplot(1,2,2);
plot(max_zq_phase(2:end));
hold on
% plot(max_sq_phase,'k');
legend('iZQC');
axis square
xlabel('ZQ echo number');
ylabel('phase (rad)');

niceFigure(gcf);
set(gcf,'name',cell2str(strcat({' Scan #'},{num2str(fields.Last_series_number_used)})));

%% write snr of first ZQ echo
signal=max(max(abs(squeeze(s(1,max_coil,2,:,:)))));
noise=std(reshape(real(squeeze(s(1,max_coil,2,(end-10):end,(end-10):end))),1,121));
snr_str=round(num2str(signal/noise));
display(cell2str(strcat({'iZQC SNR was: '},{snr_str})));

% %2D iZQC spectrum
% f_=figure;
% scale_figure=2.5;
% pos=get(f_,'OuterPosition');
% new_pos=[0 0 scale_figure*pos(3) 1.5*pos(4)];
% set(gcf,'OuterPosition',new_pos);
% subplot(1,3,1);
% display2DSpectrumD(abs(squeeze(s(1,1,1,:,:))),f1_bw,0,f1_bw,oprbw,0,f1_bw);
% axis image
% title('iZQC spectrum','FontSize',15);
% 
% %2D SQC spectrum
% subplot(1,3,2);
% imagesc(abs(squeeze(s(1,1,2,:,:))));
% axis image off
% title('Spin Echo spectrum','FontSize',15);
% 
% %find 1d indirect spectrum
% subplot(1,3,3);
% 
% [r,c]=maxRowColIndex(abs(squeeze(s(1,1,1,:,:))));
% f1_spect=abs(squeeze(s(1,1,1,:,c)));
% bw_f1=1e6*fields.yres/(fields.variable_48-fields.variable_47);
% hz_f1=-0.5*bw_f1:bw_f1/(size(s,4)-1):0.5*bw_f1;
% plot(hz_f1,f1_spect/max(f1_spect));
% xlabel('frequency (Hz)')
% ylabel('intensity (a.u.)');
% title('iZQC spectrum)');
% set(gca,'FontSize',15);
% axis square
% xlim([-700 700]);
% pos=get(gcf,'OuterPosition');

% %show raw time data for each coil
% figure
% for coil_num=1:size(td,2)
%     subplot(2,4,coil_num)
%     imagesc(squeeze(abs(td(1,coil_num,2,:,:))));
%     title(strcat('coil #',num2str(coil_num)));
%     axis square
% end

end

function exp_name = expName(directory)
slash=strfind(directory,'\');
exp_name=directory(slash(end-1)+1:slash(end)-1);
end