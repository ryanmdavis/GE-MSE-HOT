        function obj = addRoi(obj,new_ROI) %adds ROI and returns size of new list
        new_roi_num = 0;
            for roi_num = obj.length+1:obj.length + size(new_ROI,2)
                new_roi_num = new_roi_num + 1;
                obj.length = obj.length + 1;
                obj.rois(obj.length) = new_ROI(new_roi_num);
            end