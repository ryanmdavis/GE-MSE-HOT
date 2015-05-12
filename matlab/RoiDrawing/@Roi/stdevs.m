function varargout = stdevs(obj,varargin)
invar = struct('return_sem',false);
argin = varargin;
invar = generateArgin(invar,argin);
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
    min_time = 1;
    max_time = file.ntimes;
else
    error('invalid input at getRoiAvgs');
end

zvals = zeros(1,max_time - min_time + 1);

mask = obj.getMask;

values = zeros(1,max_time - min_time + 1);
roi_size = values;
for timepoint = min_time:max_time
    if isa(varargin{1},'OpenImage')
        img = reshape(double(file.read(slice,timepoint)),file.nrows,file.ncols);
    else
        img = reshape(images(timepoint,:,:),size(images,2),size(images,3));
    end
    
    values(timepoint) = std(img(mask));
    roi_size(timepoint) = sum(sum(mask));
end

if invar.return_sem
    values = values ./ (roi_size.^.5);
end

if nargout >= 1 
    varargout{1} = values;
end
if nargout == 2
    varargout{2} = sems;
end