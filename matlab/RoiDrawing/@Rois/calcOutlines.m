function obj = calcOutlines(obj)
num_rois = obj.getLength;
SE = strel('disk',1);
iso_lines(1:num_rois) = struct('value',[],'percent',0);
for roi_num = num_rois:-1:1
    mask = obj.getSpecRoi(roi_num).getMask;
    contour = imdilate(mask,SE) - mask;
    new_lines = findIsoLine2(contour,roi_num/num_rois);
    iso_lines(roi_num:roi_num + size(new_lines,2)-1) = new_lines;
end 
obj.iso_lines = iso_lines;