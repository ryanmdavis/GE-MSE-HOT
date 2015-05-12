function display2DSpectrumE(spectrum,f1_bw,f1_plot_center_fq,f1_plot_bw,f2_bw,f2_plot_center_fq,f2_plot_bw,varargin)

invar = struct('colorbar',0,'num_tick_x',5,'num_tick_y',5);
argin = varargin;
invar = generateArgin(invar,argin);

% display and format image
imagesc(spectrum);
% set(gca,'FontSize',18);
axis image
if invar.colorbar 
    colorbar
end

% set the plot limits
x_plot_lim = round(1+ (size(spectrum,2)-1)*[(0.5 - 0.5*f2_plot_bw/f2_bw) (0.5 + 0.5*f2_plot_bw/f2_bw)]);
x_plot_lim(1)=x_plot_lim(1)-0.5;
x_plot_lim(2)=x_plot_lim(2)+0.5;
y_plot_lim = round(1+ (size(spectrum,1)-1)*[(0.5 - 0.5*f1_plot_bw/f1_bw) (0.5 + 0.5*f1_plot_bw/f1_bw)]);
y_plot_lim(1)=y_plot_lim(1)-0.5;
y_plot_lim(2)=y_plot_lim(2)+0.5;
xlim(x_plot_lim);
ylim(y_plot_lim);

% calculate the voxels with tick marks
x_tick_vox=linspace(x_plot_lim(1),x_plot_lim(2),invar.num_tick_x);
y_tick_vox=linspace(y_plot_lim(1),y_plot_lim(2),invar.num_tick_y);

% calculate the location of tick marks on the range [-0.5,0.5]
x_tick_norm=x_tick_vox/size(spectrum,2)-0.5;
y_tick_norm=y_tick_vox/size(spectrum,2)-0.5;

% calculate the location of the tick marks in normalized coord. [0 1]
x_tick_locations=x_tick_norm+0.5; set(gca,'XTick',x_tick_vox);
y_tick_locations=y_tick_norm+0.5; set(gca,'YTick',y_tick_vox);

round_digit_f1=round(log10(f1_bw))-2;
round_digit_f2=round(log10(f2_bw))-2;

for x=1:invar.num_tick_x
    x_ticks{x} = num2str(roundn(x_tick_norm(x) * f2_bw,round_digit_f2));
end

for y=1:invar.num_tick_y
    y_ticks{y} = num2str(roundn(y_tick_norm(y) * f1_bw,round_digit_f1));
end

set(gca,'XTickLabel',x_ticks);
set(gca,'YTickLabel',y_ticks);