function obj = deleteRoi(obj,roi_num)
    obj.length = obj.length - 1;
    temp = Roi.empty(obj.length,0);
    temp(1:roi_num - 1) = obj.rois(1:roi_num - 1);
    if roi_num < max(size(obj.rois))
        temp(roi_num:obj.length) = obj.rois(roi_num + 1:obj.length + 1);
    end

    clear obj.rois;
    obj.rois = temp;
end