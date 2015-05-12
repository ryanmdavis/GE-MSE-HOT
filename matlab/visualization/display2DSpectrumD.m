function display2DSpectrumD(spectrum,f1_bw,f1_plot_center_fq,f1_plot_bw,f2_bw,f2_plot_center_fq,f2_plot_bw,varargin)

invar = struct('colorbar',0);
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

% % if first voxel does not have an xtick, give it one
% xtick=get(gca,'XTick');
% if xtick(1)~=1 xtick=[1 xtick]; end
% set(gca,'XTick',xtick);
% ytick=get(gca,'YTick');
% if ytick(1)~=1 ytick=[1 ytick]; end
% set(gca,'YTick',ytick);

num_x_ticks = max(size(get(gca,'XTick')));
num_y_ticks = max(size(get(gca,'YTick')));

x_tick_locations = (get(gca,'XTick')-1)/(size(spectrum,2)-1)-0.5;
y_tick_locations = (get(gca,'YTick')-1)/(size(spectrum,1)-1)-0.5;

round_digit_f1=round(log10(f1_bw))-2;
round_digit_f2=round(log10(f2_bw))-2;

for x=1:num_x_ticks
    x_ticks{x} = num2str(roundn(x_tick_locations(x) * f2_bw,round_digit_f2));
end

for y=1:num_y_ticks
    y_ticks{y} = num2str(roundn(y_tick_locations(y) * f1_bw,round_digit_f1));
end

set(gca,'XTickLabel',x_ticks);
set(gca,'YTickLabel',y_ticks);