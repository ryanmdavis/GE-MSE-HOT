function num_pix = getNumPix(obj)
num_pix = zeros(obj.getLength,1);
for roi_num = 1:obj.getLength
    num_pix(roi_num) = obj.getSpecRoi(roi_num).getNumPix;
end