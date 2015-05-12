% Ryan M Davis-08/2014

function niceFigure(f_h,varargin)
invar = struct('fs',18);
argin = varargin;
invar = generateArgin(invar,argin);
fs=invar.fs;%font size

legend_handle=findobj(f_h,'Type','axes','Tag','legend');
figure_axes_handles=findobj(f_h,'Type','axes','-not','Tag','legend');

% change fontsize of axes objects
for figure_axes_handle_num=1:size(figure_axes_handles,1)
    
    % Axes font size
    axes_handles=findobj(figure_axes_handles(figure_axes_handle_num),'Type','Axes');
    for ah_num=1:size(axes_handles,1)
        set(axes_handles(ah_num),'FontSize',fs);
    end
    
    % label and title font sizes
    xyt=[get(axes_handles(ah_num),'xlabel') get(axes_handles(ah_num),'ylabel') get(axes_handles(ah_num),'title')];
    for xyt_num=1:3;
        set(xyt(xyt_num),'FontSize',fs);
    end
    
    % make lines thicker
    lines=findobj(axes_handles(ah_num),'Type','line');
    for line_num=1:size(lines,1)
        set(lines(line_num),'LineWidth',2);
    end
    
    % make axes thicker
    set(axes_handles(ah_num),'LineWidth',2);
    
    % make data markers and patches thicker
    patch_handles=findobj(figure_axes_handles(figure_axes_handle_num),'Type','Patch');
    set(patch_handles,'LineWidth',2);

end