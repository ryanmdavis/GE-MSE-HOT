function drawContour(obj,varargin)
invar = struct('axes_h',gca,'width',1,'color','b','style','-');
argin = varargin;
invar = generateArgin(invar,argin);
axes(invar.axes_h)
line(obj.col_points,obj.row_points,'linewidth',invar.width,'color',invar.color,'linestyle',invar.style);
if obj.isContourClosed
    num_pixels = size(obj.row_points,1);
    line([obj.col_points(1) obj.col_points(num_pixels)],[obj.row_points(1) obj.row_points(num_pixels)],'linewidth',invar.width,'color',invar.color,'linestyle',invar.style);
end