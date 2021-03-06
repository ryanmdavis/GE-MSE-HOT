function patchRois(varargin)
    if size(varargin,2) == 1
        obj = varargin{1};
        roi_list = 1:obj.getLength;
    elseif size(varargin,2) == 2
        obj = varargin{1};
        if ~isint(varargin{2}) %if arg is not an int, assume it is a handle
            subplot(varargin{2});
            roi_list = 1:obj.getLength;
        else %if arg is an int/array of ints, assume it specs roi
            roi_list = varargin{2};
        end
    end
    
    for roi_num = roi_list
        [x,y] = obj.getSpecRoi(roi_num).getRoiPoints();
        color = getObjColor(roi_num);
        patch(x,y,color);
    end


% function patchRois(obj)
%     if size(varargin,2) == 1
%         axes(varargin{1});
%     end
%     for roi_num = 1:obj.getLength()
%         [x,y] = obj.getSpecRoi(roi_num).getRoiPoints();
%         color = getObjColor(roi_num);
%         patch(x,y,color);
%     end