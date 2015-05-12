function obj = setGroup(obj,group)
    for roi_num = 1:obj.length
        obj.rois(roi_num).setGroup(group);
    end