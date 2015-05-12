for pre_num = 1 : obj_pre.getLength
    for post_num = 1 : obj_post.getLength
        post_mask = obj_post.getSpecRoi(post_num).getMask;
        pre_mask = obj_pre.getSpecRoi(pre_num).getMask;
        obj_pre.rois(pre_num).setMask(post_mask & pre_mask);
    end
end