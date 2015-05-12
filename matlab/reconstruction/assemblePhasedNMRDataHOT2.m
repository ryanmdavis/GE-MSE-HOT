%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% assemblePhasedNMRDataHOT2 - assemble phased array data.  Assume
% SQ-ZQ-ZQ-ZQ... echoes
% input is image domain data with dimensions:
%   1) repetition 2) coil number  3) coherence number 4) row  5) column   
% Uses Roemer et al.  
% Assumes 
%   1)no coil coupling (noise resistance matrix is
%   identity) and assumes that phase of SE image should be pi/2 radians.
%   2)second window is SE data (i.e. input(:,2,:,:,:) are part of the SE
%   image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function assembled_images = assemblePhasedNMRDataHOT2(images,data_type,varargin)

if size(size(images)) ~= 5 error('input must have 5 dimensions'); end

if (size(varargin,1) == 0) || sum((varargin{1} == 0)) %combine data from all elements
    coil_elements = 1:size(images,2);
else                      %combine data from specified elements
    coil_elements = varargin{1};
end
 
assembled_images = zeros(size(images,1),size(images,3),size(images,4),size(images,5));

if strcmp(data_type,'image')
    %SE data:
    s=size(images);
    assembled_images(:,1,:,:) = reshape(sqrt(sum(images(:,coil_elements,1,:,:).*conj(images(:,coil_elements,1,:,:)),2)),[s(1) 1 s(4) s(5)]);
    
    %iZQC data:
    for echo_num=2:size(images,3)
        if getHOTReconOption('weight_iZQC')
             % weighted by the fat proton density
            assembled_images(:,echo_num,:,:) = reshape(sqrt(sum(images(:,coil_elements,echo_num,:,:).*conj(images(:,coil_elements,1,:,:)))),[s(1) 1 s(4) s(5)]);
        else
             % not weighted by the fat proton density
            assembled_images(:,echo_num,:,:) = reshape(sqrt(sum(images(:,coil_elements,echo_num,:,:).*conj(images(:,coil_elements,1,:,:))./abs(images(:,coil_elements,1,:,:)),2)),[s(1) 1 s(4) s(5)]);
        end
    end
    assembled_images=reshape(assembled_images,[1 size(assembled_images)]);
elseif strcmp(data_type(1:6),'spectr')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Still cannot reproduce GE recon for spectra
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5%%%
    rows = zeros(1,size(images,5));
    cols = zeros(1,size(images,5));
    for coil_num = 1:size(images,5)
        [rows(coil_num),cols(coil_num)]=maxRowColIndex(images(1,1,:,:,coil_num));
        assembled_images(:,2,:,:) = assembled_images(:,2,:,:)+reshape(images(:,2,:,:,coil_num)*conj(images(:,1,rows(coil_num),cols(coil_num),coil_num))*exp(1i*pi/2),size(images,1),1,size(images,3),size(images,4));
        assembled_images(:,1,:,:) = assembled_images(:,1,:,:)+reshape(images(:,1,:,:,coil_num)*conj(images(:,1,rows(coil_num),cols(coil_num),coil_num))*exp(1i*pi/2),size(images,1),1,size(images,3),size(images,4));
    end
    %SE data:
    assembled_images(:,2,:,:) = sqrt(assembled_images(:,2,:,:))*exp(1i*pi/2);

    %iZQC data:
    assembled_images(:,1,:,:) = sqrt(assembled_images(:,1,:,:))*exp(1i*pi/2);
end