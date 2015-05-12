function outlineRois(obj,varargin)
invar = struct('axes_h',gca,'linewidth',1,'f_h',gcf,'range',1,'color',[],'shift',[0 0],'scale',1);
argin = varargin;
invar = generateArgin(invar,argin);
if mod(size(varargin,2),2) == 1
    error('inappropriate arguments')
end
if invar.range == 1
    range = 1:obj.getLength;
end
axes(invar.axes_h);
for roi_num = range
    if isempty(invar.color)
        if ~isempty(obj.rois(roi_num).getGroup)
            group = obj.rois(roi_num).getGroup;
            obj.rois(roi_num).drawContour('color',group(1),'axes_h',invar.axes_h,'f_h',invar.f_h,'width',invar.linewidth,'style',group(2:end),'shift',invar.shift,'scale',invar.scale);
        else
            obj.rois(roi_num).drawContour('color',getObjColor(roi_num),'axes_h',invar.axes_h,'f_h',invar.f_h,'width',invar.linewidth,'shift',invar.shift,'scale',invar.scale);
        end
    else
        obj.rois(roi_num).drawContour('color',invar.color,'axes_h',invar.axes_h,'f_h',invar.f_h,'width',invar.linewidth,'shift',invar.shift,'scale',invar.scale);
    end
end
    

% iso_line_list = 1/obj.getLength:1/obj.getLength:1;
% displayIsoLines(obj.iso_lines,iso_line_list,invar.linewidth,'reverse_draw_order');