function obj = saveRois(obj,source,varargin)
if size(varargin,2) == 1
    info = varargin{1};
else
    info = '';
end

    if strcmp(source(2:3),':\') %if the file path is absolute
        path = source;
        fid = fopen(source,'r','l');
    else
        path = strcat(pwd,'\',source);
        fid = fopen(path,'r','l'); %else, source must be the file name
    end
    
    path = [path '.roi'];
    
fid = fopen(path,'w','l');

fwrite(fid,single(size(info,2)),'single');
if size(info,2) > 0
    fwrite(fid,single(info),'single');
end
fwrite(fid,double(obj.getLength),'single');
fwrite(fid,size(obj.getSpecRoi(1).getMask,1),'single');
fwrite(fid,size(obj.getSpecRoi(1).getMask,2),'single');

for roi_num = 1: obj.getLength
    group = obj.getSpecRoi(roi_num).getGroup;
    group_length = size(group,2);
    y_points = obj.getSpecRoi(roi_num).getContour.getRowPts;
    x_points = obj.getSpecRoi(roi_num).getContour.getColPts;
    x_points_length = max(size(x_points));
    y_points_length = max(size(y_points));
    fwrite(fid,group_length,'single');
    if group_length > 0 
        fwrite(fid,single(group),'single');
    end
    fwrite(fid,x_points_length,'single');
    if x_points_length > 0
        fwrite(fid,x_points,'single');
    end
    fwrite(fid,y_points_length,'single');
    if x_points_length > 0
        fwrite(fid,y_points,'single');
    end
end

fclose(fid);