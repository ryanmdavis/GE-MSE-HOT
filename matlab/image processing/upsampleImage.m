% This function takes an image as input, ffts it, zero fills the resulting 
% frequency domain data, then iffts the zero-filled frequency domain data.
% If upsample_factor < 1, then instead of zero filling, this function
% will truncate the frequency domain data, resulting in a smaller image.
%
% input:
%   image: data to be "Upsampled". spatial dimensions must be the last two 
%       dimensions of data matrix
%   upsample_factor: factor that image size will be increased by.  
% output: the upsampled/downsampled data.

function i_up = upsampleImage(image,upsample_factor)

num_dim = max(size(size(image)));

max_size = max([size(image,num_dim) size(image,num_dim-1)]);
recon_size = max_size*upsample_factor;

k = fftshift(fftshift(fft(fft(fftshift(fftshift(image,num_dim),num_dim-1),[],num_dim),[],num_dim-1),num_dim),num_dim-1);

if upsample_factor >= 1
    if num_dim > 2
        i_up = fftshift(fftshift(ifft(ifft(ifftshift(ifftshift(zeroPadImageC(k,[recon_size recon_size]),num_dim),num_dim-1),[],num_dim),[],num_dim-1),num_dim),num_dim-1);
    else
        i_up = fftshift(fftshift(ifft(ifft(ifftshift(ifftshift(zeroPadImage(k,[recon_size recon_size]),num_dim),num_dim-1),[],num_dim),[],num_dim-1),num_dim),num_dim-1);
    end
elseif upsample_factor < 1
   k_size = size(k);
   k_new_size=[k_size(end-1) k_size(end)];
   k_new_size(end)=round(k_new_size(end)*upsample_factor);
   k_new_size(end-1)=round(k_new_size(end-1)*upsample_factor);
   k_new=zeros(k_new_size);
   if num_dim==2
      k_new=k((end/2-k_new_size(1)/2+1):(end/2+k_new_size(1)/2), (end/2-k_new_size(2)/2+1):(end/2+k_new_size(2)/2));
   elseif num_dim==3
       k_new=k(:,(end/2-k_new_size(1)/2+1):(end/2+k_new_size(1)/2), (end/2-k_new_size(2)/2+1):(end/2+k_new_size(2)/2));
   elseif num_dim==4
       k_new=k(:,:,(end/2-k_new_size(1)/2+1):(end/2+k_new_size(1)/2), (end/2-k_new_size(2)/2+1):(end/2+k_new_size(2)/2));
   elseif num_dim==5
       k_new=k(:,:,:,(end/2-k_new_size(1)/2+1):(end/2+k_new_size(1)/2), (end/2-k_new_size(2)/2+1):(end/2+k_new_size(2)/2));
   end
%    i_up = fftshift(fftshift(ifft(ifft(ifftshift(ifftshift(zeroPadImage(k_new,[recon_size recon_size]),num_dim),num_dim-1),[],num_dim),[],num_dim-1),num_dim),num_dim-1);
   i_up = fftshift(fftshift(ifft(ifft(ifftshift(ifftshift(k_new,num_dim),num_dim-1),[],num_dim),[],num_dim-1),num_dim),num_dim-1);
end
i_up=i_up*upsample_factor^2;