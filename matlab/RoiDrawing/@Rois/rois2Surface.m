function surface = rois2Surface(obj)
first_mask = obj.getSpecRoi(1).getMask;
surface = zeros(size(first_mask,1),size(first_mask,2))*(obj.getLength + 1);
for roi_num = obj.getLength:-1:1 %set each roi to its own number on surface
    roi_mask = obj.getSpecRoi(roi_num).getMask;
    surface(boolean(roi_mask)) = obj.getLength - roi_num + 1;
end

surface = surface/max(max(surface)); %normalize surface