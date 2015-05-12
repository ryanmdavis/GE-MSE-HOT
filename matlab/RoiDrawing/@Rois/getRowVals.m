function xvals = getRowVals(obj)

xvals = zeros(1,obj.getLength());    
    for roi_num = 1:obj.getLength()
        centroid = obj.getSpecRoi(roi_num).getCentroid();
        xvals(roi_num) = centroid(1);
    end