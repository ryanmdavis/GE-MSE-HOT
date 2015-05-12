%For matrix input, use (time,row,col) as dimensions
function zvals = getRoiAvgs(obj,varargin)
if ~isa(varargin{1},'OpenImage')
    images = varargin{1};
    min_time = 1;
    if size(images,3) == 1 % if just a 2D image
        max_time = 1;
    else
        max_time = size(images,1);
    end
elseif isa(varargin{1},'OpenImage')
    file = varargin{1};
    slice = varargin{2};
    if size(varargin,2) == 4
        min_time = varargin{3};
        max_time = varargin{4};
    elseif size(varargin,2) == 2
        min_time = 1;
        max_time = file.ntimes;
    else
        error('invalid input at getRoiAvgs');
    end
else
    error('invalid input at getRoiAvgs');
end
    

zvals = zeros(obj.length,max_time - min_time + 1);
for timepoint = min_time:max_time
    if isa(varargin{1},'OpenImage')
        img = reshape(double(file.read(slice,timepoint)),file.nrows,file.ncols);
    elseif size(images,3) > 1
        img = reshape(images(timepoint,:,:),size(images,2),size(images,3));
    else
        img = images;
    end
    for roi_num = 1:obj.getLength()
        if isa(img,'double')
            mask = double(obj.getSpecRoi(roi_num).getMask());
        elseif isa(img,'uint32')
            mask = uint32(obj.getSpecRoi(roi_num).getMask());
        elseif isa(img,'int16');
            mask = int16(obj.getSpecRoi(roi_num).getMask());
        end
        
        nums = ~isnan(img) & ~isinf(img); 
        new_mask = nums & mask;
        masked = img(new_mask);
        total = sum(sum(masked));
        zvals(roi_num,timepoint) = total/size(masked,1);
    end
end

% zvals = calcPhaseShift(zvals');