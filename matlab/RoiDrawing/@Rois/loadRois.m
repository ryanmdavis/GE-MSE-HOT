function varargout = loadRois(obj,source)
    if strcmp(source(2:3),':\') %if the file path is absolute
        path = source;
        fid = fopen(source,'r','l');
    else
        path = strcat(pwd,'\',source);
        fid = fopen(path,'r','l'); %else, source must be the file name
    end
    
    info_length = fread(fid,1,'single');
    info = char(fread(fid,info_length,'single'));
    roi_length = fread(fid,1,'single');
    nrows = fread(fid,1,'single');
    ncols = fread(fid,1,'single');
    
for roi_num = 1: roi_length
    group_length = fread(fid,1,'single');
    group = char(fread(fid,group_length,'single'))';
    x_points_length  = fread(fid,1,'single');
    x_points = fread(fid,x_points_length,'single');
    y_points_length = fread(fid,1,'single');
    y_points = fread(fid,y_points_length,'single');
    ROI = Roi(poly2mask(y_points,x_points,nrows,ncols)','input_type','masks','contour_points',[y_points,x_points]);
    if group_length > 0
        ROI.setGroup(group);
    end
    obj.addRoi(ROI);    
end

fclose(fid);

if nargout == 1 
    varargout{1} = info;
end