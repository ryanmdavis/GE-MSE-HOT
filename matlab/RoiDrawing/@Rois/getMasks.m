function masks = getMasks(obj)
masks = zeros(obj.getLength,size(obj.getSpecRoi(1).getMask,1),size(obj.getSpecRoi(1).getMask,2));
for mask_num = 1:obj.getLength
    masks(mask_num,:,:) = reshape(obj.getSpecRoi(mask_num).getMask,1,size(masks,2),size(masks,3));
end
masks=squeeze(masks);