function obj_return = and(obj_pre,obj_post)
for pre_num = 1 : obj_pre.getLength
    mask_temp = boolean(zeros(size(obj_pre.getSpecRoi(1).getMask)));
    for post_num = 1 : obj_post.getLength
        post_mask = obj_post.getSpecRoi(post_num).getMask;
        pre_mask = obj_pre.getSpecRoi(pre_num).getMask;
        mask_temp = mask_temp | (post_mask & pre_mask);
    end
    obj_pre.rois(pre_num) = obj_pre.rois(pre_num).setMask(mask_temp);
    obj_pre.rois(pre_num) = obj_pre.rois(pre_num).refreshProperties(); %recalculates num_pix and centroid for new ROI mask
end
obj_return = obj_pre;