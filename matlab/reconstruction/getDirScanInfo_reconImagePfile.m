% this function just calls the main reconstruction functions 
% (reconGeHotTemp,reconGeHotTemp2) and then displays the data

function out = getDirScanInfo_reconImagePfile(directory)

fields = struct('variable_37',[]);
fields = getGeHdrEntry(strcat(directory,'_header.txt'),fields);

if fields.variable_37==2
    shift=[getHOTReconOption('row_shift') getHOTReconOption('col_shift')];
    out = reconGeHotTemp2(directory,'shift',shift);   

    %% display multi echo and t temperature    
    if getHOTReconOption('display')
        title1='spin echo window';
        title2='iZQC window';
        [c,r]=autoSubplotSize(size(out.i,3)+1);

        figure,subplot(c,r,1);
        imagesc(intensity2RGB(squeeze(abs(out.i(1,1,1,:,:))),gray));
        axis image off
        title(title1,'FontSize',15);

        iZQC_intensity_range=[0 max(max(abs(squeeze(out.i(1,1,2,:,:)))))];
        for echo_num=2:size(out.i,3)
            subplot(c,r,echo_num);
            imagesc(intensity2RGB(squeeze(abs(out.i(1,1,echo_num,:,:))),gray,iZQC_intensity_range));
            axis image off
            title(strcatspace(title2,' ',num2str(echo_num-1)),'FontSize',15);
        end

        % show echo averaged image
        subplot(c,r,r*c);
        i_scale=3;
        imagesc(intensity2RGB(abs(squeeze(out.pd_ave)),gray,iZQC_intensity_range*i_scale));
        axis image off
        title({'echo averaged image',strcatspace('intensity scale x ',num2str(i_scale))});

        % format multi-echo figure
        niceFigure(gcf);
        set(gcf,'Position',[-1 74 638 742]);

        % show temperature map
        figure,
        t_range=[10 40];
        mask=squeeze(abs(out.i(1,1,1,:,:)))>0.25*max(max(squeeze(abs(out.i(1,1,1,:,:)))));
        t_thresh = imageToBlackBackgroundB(squeeze(out.t_ave(1,1,1,:,:)),mask,t_range,hot);
        imagesc(t_thresh,t_range)
        axis image off
        title('echo_avg T (\circC)','FontSize',15);
        colormap hot
        colorbar
        niceFigure(gcf);
        set(gcf,'Position',[652 425 527 391]);
        out.t_rgb=t_thresh;
    end

else
    [im,k,t] = reconGeHotTemp(directory,'shift',[0 0]);
    out=struct('i',im,'k',k,'t',t);
    
    title2='spin echo window';
    title1='zero quantum window';
    figure
    subplot(1,3,1);
    imagesc(squeeze(abs(im(1,1,1,:,:))));
    axis image off
    title(title1,'FontSize',15);
    subplot(1,3,2);
    imagesc(squeeze(abs(im(1,1,2,:,:))))
    axis image off
    title(title2,'FontSize',15);
    subplot(1,3,3);
    imagesc(squeeze(abs(t)),[20 45])
    axis image off
    title('Temperature','FontSize',15);
    colorbar
    pos=get(gcf,'OuterPosition');
    scale_figure=2.5;
    new_pos=[0 0 scale_figure*pos(3) pos(4)];
    set(gcf,'OuterPosition',new_pos);
end

