% Ryan M Davis-08/2014

function niceFigure(f_h,varargin)

% define font name
fontname='Calibri';

legend_handle=findobj(f_h,'Type','axes','Tag','legend');
figure_axes_handles=findobj(f_h,'Type','axes','-not','Tag','legend');

% get size of figure in points
old_units=get(f_h,'Units');
set(f_h,'Units','points');
pos=get(f_h,'Position');
fig_dim_points=max(pos(3:4));

% read optional inputs
invar = struct('format',0,'fs_adjust',1);
argin = varargin;
invar = generateArgin(invar,argin);

% set figure properties to be used below
if invar.format==1
    linewidth   =round(invar.fs_adjust*fig_dim_points/30);
    markersize  =round(invar.fs_adjust*fig_dim_points/10);
    fontsize    =round(invar.fs_adjust*fig_dim_points/50);
elseif invar.format==0
    linewidth   =round(invar.fs_adjust*fig_dim_points/80);
    markersize  =round(invar.fs_adjust*fig_dim_points/35);
    fontsize    =round(invar.fs_adjust*fig_dim_points/24);
elseif invar.format==2 %histogram
    linewidth   =round(invar.fs_adjust*fig_dim_points/320);
    markersize  =round(invar.fs_adjust*fig_dim_points/35);
    fontsize    =round(invar.fs_adjust*fig_dim_points/24);
else
    linewidth   =round(invar.fs_adjust*fig_dim_points/50);
    markersize  =round(invar.fs_adjust*fig_dim_points/10);
    fontsize    =round(invar.fs_adjust*fig_dim_points/50);
end

% change fontsize of axes objects
for figure_axes_handle_num=1:size(figure_axes_handles,1)
    % set font
    set(figure_axes_handles(figure_axes_handle_num),'FontName',fontname);
    
    % Axes font size
    axes_handles=findobj(figure_axes_handles(figure_axes_handle_num),'Type','Axes');
    for ah_num=1:size(axes_handles,1)
        set(axes_handles(ah_num),'FontSize',fontsize);
    end
    
    % label and title font sizes
    xyt=[get(axes_handles(ah_num),'xlabel') get(axes_handles(ah_num),'ylabel') get(axes_handles(ah_num),'title')];
    for xyt_num=1:3;
        set(xyt(xyt_num),'FontSize',fontsize);
        set(xyt(xyt_num),'FontName',fontname);
    end
    
    % make lines thicker
    lines=findobj(axes_handles(ah_num),'Type','line');
    for line_num=1:size(lines,1)
        set(lines(line_num),'LineWidth',linewidth);
    end
    
    % make axes thicker
    set(axes_handles(ah_num),'LineWidth',2);
    
    % make data markers and patches thicker
    patch_handles=findobj(figure_axes_handles(figure_axes_handle_num),'Type','Patch');
    set(patch_handles,'LineWidth',linewidth);
    set(patch_handles,'MarkerSize',markersize);
    
    % make text thicker
    strings=findobj(axes_handles(ah_num),'Type','Text');
    set(strings,'FontSize',fontsize);
    set(strings,'FontName',fontname);
end

set(gca,'box','on');
set(f_h,'Units',old_units);