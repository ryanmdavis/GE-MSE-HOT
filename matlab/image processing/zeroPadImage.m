%%make i into a matrix with size = mat_size
%%%% works with ND data, as long as first two dims are row and column

function i_out = zeroPadImage(i,mat_size)

i_out = zeros(mat_size(1),mat_size(2),size(i,3),size(i,4));
row_start = (size(i_out,1) - size(i,1))/2 + 1;
col_start = (size(i_out,2) - size(i,2))/2 + 1;

i_out(row_start:row_start + size(i,1) - 1,col_start:col_start + size(i,2) - 1,:,:) = i;