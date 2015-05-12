function [centroid,num_pix] = findCentroid(obj)
    mask = obj.getMask();
    num_pix = 0;
    num_zeros = 0;
    cent_row= 0;
    cent_col = 0;
    for row = 1:size(mask,1)
        for col = 1:size(mask,2)
            if mask(row,col) == 1;
                
                num_pix = num_pix + 1;
                cent_row = cent_row + row;
                cent_col = cent_col + col;
            else
                num_zeros = num_zeros + 1;
            end
        end
    end
     cent_row = cent_row / num_pix;
     cent_col = cent_col / num_pix;
     centroid = [cent_row,cent_col];