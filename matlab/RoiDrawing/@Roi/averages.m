function values = averages(obj,varargin)
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

zvals = zeros(1,max_time - min_time + 1);

mask = obj.getMask;

for timepoint = min_time:max_time
    if isa(varargin{1},'OpenImage')
        img = reshape(double(file.read(slice,timepoint)),file.nrows,file.ncols);
    else
        img = reshape(images(timepoint,:,:),size(images,2),size(images,3));
    end
    
    values(timepoint) = sum(sum(mask .* img)) / sum(sum(mask));
    
end