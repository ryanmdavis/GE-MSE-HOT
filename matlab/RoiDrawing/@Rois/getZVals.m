function zvals = getRoiAvgs(obj,img)

zvals = zeros(1,obj.getLength());    
    for roi_num = 1:obj.getLength()
        mask = obj.getSpecRoi(roi_num).getMask();
        masked = mask .* img;
        total = sum(sum(masked));
        zvals(roi_num) = total/obj.getSpecRoi(roi_num).getNumPix();
    end