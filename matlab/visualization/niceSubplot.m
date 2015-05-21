function niceSubplot(f_h)
outer_margin=0.1;
inner_margin=0.02;

old_units=get(f_h,'Units');
set(f_h,'Units','Normalized');
subplot_handles=flipud(findobj(f_h,'Type','axes','-not','Tag','legend'));
pos_cell=get(subplot_handles,'Position');
for sp_num=1:size(pos_cell,1)
    pos_col(sp_num)=pos_cell{sp_num}(1);
end

colss=find(pos_col==pos_col(1),2); cols=colss(2)-1;
rows=ceil(size(pos_cell,1)/cols);

% only do anything if this is really a figure with subplots
if (rows>1)||(cols>1)
    % find how much of figure is dedicated to axes
    total_active_width=1-outer_margin*2-inner_margin*(cols-1);
    total_active_height=1-outer_margin*2-inner_margin*(rows-1);

    % find size of subplots
    subplot_width=total_active_width/cols;
    subplot_height=total_active_height/rows;

    % set subplot axis positions
    for sp_num=1:size(subplot_handles,1)
        row=floor((sp_num-1)/cols)+1;
        col=mod(sp_num-1,cols)+1;
        axis_num=col+cols*(row-1);
        horizontal_position=(outer_margin+(col-1)*(subplot_width+inner_margin));
        vertical_position=1-(outer_margin+subplot_height+(row-1)*(subplot_height+inner_margin));
        set(subplot_handles(axis_num),'Position',[horizontal_position vertical_position subplot_width subplot_height]);
    end

    % make sure the aspect ratio is correct
    set(f_h,'Units','inches');
    figure_position=get(f_h,'Position');
    figure_dim=figure_position(3);
    set(f_h,'Position',[0 0 figure_dim figure_dim/cols*rows]);
end

% change the figure units back to what they were when the function was
% called
set(f_h,'Units',old_units);