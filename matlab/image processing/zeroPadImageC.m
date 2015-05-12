%%make i into a matrix with size = mat_size
%%%% works with 4D data, as long as last two dims are row and column

function i_out = zeroPadImageC(i,mat_size)

num_dim = max(size(size(i)));

i_out_size = size(i);
i_out_size(end-1) = mat_size(1);
i_out_size(end) = mat_size(2);

i_out = zeros(i_out_size);
row_start = (size(i_out,num_dim-1) - size(i,num_dim-1))/2 + 1;
col_start = (size(i_out,num_dim) - size(i,num_dim))/2 + 1;

if max(size(size(i_out)))==4
    i_out(:,:,row_start:row_start + size(i,num_dim-1) - 1,col_start:col_start + size(i,num_dim) - 1) = i;
elseif max(size(size(i_out)))==3
    i_out(:,row_start:row_start + size(i,num_dim-1) - 1,col_start:col_start + size(i,num_dim) - 1) = i;
elseif max(size(size(i_out)))==5
    i_out(:,:,:,row_start:row_start + size(i,num_dim-1) - 1,col_start:col_start + size(i,num_dim) - 1) = i;
end