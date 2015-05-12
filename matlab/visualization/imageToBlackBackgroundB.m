%%%pass the normal image matrix to this function, and pass a binary image with
%%%background = 0 and everything else = 1
function im_mod = imageToBlackBackgroundB(im,foreground_map,intensity_range,colormap)

if ((max(max(im)) > max(intensity_range)) || (min(min(im)) < min(intensity_range)))
    %warning('range of image exceeds specified intensity range');
    im(im > max(intensity_range)) = max(intensity_range);
    im(im < min(intensity_range)) = min(intensity_range);
end

if (sum(size(foreground_map) == [1 1]) == 2) && foreground_map == 1
    foreground_map = ones(size(im));
end
intensity_range_total = max(intensity_range) - min(intensity_range);

im_lin = reshape(im,1,size(im,1)*size(im,2));
foreground_map_lin = reshape(foreground_map,1,size(im,1)*size(im,2));
im_lin_pos = im_lin - min(intensity_range);
im_lin_scale = im_lin_pos/intensity_range_total;
im_lin_jet = colormap(round(im_lin_scale*(size(colormap,1)-1)+1),:);
im_lin_jet(~foreground_map_lin,:) = 0;
im_mod = reshape(im_lin_jet,size(im,1),size(im,2),3);