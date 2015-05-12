function i_rgb=superpose2RGB(foreground_img,background_img,foreground_mask)

if size(background_img,3)~=3 || size(foreground_img,3)~=3
    error('first two images must be NxNx3 matricies');
end

for channel = 1:3 
    background_img(:,:,channel)=background_img(:,:,channel).*~foreground_mask; 
    foreground_img(:,:,channel)=foreground_img(:,:,channel).*foreground_mask; 
end
i_rgb=background_img+foreground_img;