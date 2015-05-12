function out = scanSpecificAdjustment(in,adj_num)
switch adj_num
    
    % case 1: RMD332
    % I was not setting the imaging receiver frequency correctly for echoes
    % > 2.  Instead of throwing away the whole dataset, just shift the
    % images in the read encode direction during post processing.
    case 1
        read_offset_mm=-34.862; % see C:\Users\Ryan2\Documents\Warren Lab Work\GE 3T data\RMD332\P30720.7_04031503_header.txt
        fov_mm= 160;
        read_mat=32;
        
        %image adjustment
        out=in;
        for dim1=1:size(in,1)
            for dim2=1:size(in,2)
                for dim3=3:size(in,3)
                    out(dim1,dim2,dim3,:,:) = circshift(in(dim1,dim2,dim3,:,:),[0 0 0 round(read_offset_mm/fov_mm*read_mat) 0]);
                end
            end
        end
        
        %kspace adjustment
%         k=fftNd(in);
%         clear in
%         phase_adjust=-(read_offset_mm*size(k,4)/fov_mm)*linspace(-pi,pi,size(k,4)).'*ones(1,size(k,5));
%         for dim1=1:size(k,1)
%             for dim2=1:size(k,2)
%                 for dim3=3:size(k,3)
%                     k(dim1,dim2,dim3,:,:)=squeeze(k(dim1,dim2,dim3,:,:)).*exp(1i*phase_adjust);
%                 end
%             end
%         end
%         out=ifftNd(k);
        
    %case 2: RMD333
    % for unknown reason, the second iZQC echo in this dataset is
    % incredibly noisy.  The second echo is ommitted from echo averaging.
    case 2
        out=[1 3 4];
        
    %case 3: RMD332
    % for unknown reason, the first iZQC echo in this dataset is showing a
    % decrease rather than increase in temperature for this dataset, which
    % causes destructive interference in the phase images during averaging.
    case 3
        out=[2 3 4];
    otherwise
        error('invalid adjustment number'); 
end