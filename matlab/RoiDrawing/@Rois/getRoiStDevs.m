%% this function uses square root(avg(masked_image^2) - avg(masked_image)^2)

function stdev = getRoiStDevs(obj,input_img)
    stdev = zeros(obj.getLength(),1);
    if size(input_img,3) == 1
        num_timepoints = 1;
    else 
        num_timepoints = size(input_img,1);
    end
    
    for timepoint = 1:num_timepoints
        if size(input_img,3) == 1
            img = double(input_img);
        else
            img = double(reshape(input_img(timepoint,:,:),size(input_img,2),size(input_img,3)));
        end
        for roi_num = 1:obj.getLength()
            mask = double(obj.getSpecRoi(roi_num).getMask());
            masked = mask .* img;
            total = sum(sum(masked));
            img_avg = total/obj.getSpecRoi(roi_num).getNumPix();
            
            masked_sqr = masked.^2;
            total_masked_sqr = sum(sum(masked_sqr));
            avg_masked_sqr = total_masked_sqr/obj.getSpecRoi(roi_num).getNumPix();
            
            stdev(roi_num,timepoint) = (avg_masked_sqr - img_avg^2)^(1/2);
        end
    end