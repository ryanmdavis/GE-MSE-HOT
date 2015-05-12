function yvals = getYVals(obj)

yvals = zeros(1,obj.getLength());    
    for roi_num = 1:obj.getLength()
        centroid = obj.getSpecRoi(roi_num).getCentroid();
        yvals(roi_num) = centroid(2);
    end