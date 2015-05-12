function roi_return = getSpecRoi(obj,varargin)
    if isa(varargin{1},'double')
        roi_return = obj.rois(varargin{1});
    elseif isa(varargin{1},'char')
        num_rois_return = 0;
        roi_return = Roi.empty(obj.length,0);
        for roi_num = 1:obj.length
            if strcmp(obj.rois(roi_num).getGroup,varargin{1})
                num_rois_return = num_rois_return + 1;
                roi_return(num_rois_return) = obj.rois(roi_num);
            end
        end
        if num_rois_return == 0 
            clear roi_return;
            roi_return = [];
        end
    else
        error('input must be either an index (double) or a group name (string')
    end      