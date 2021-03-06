%make sure that this is not accessing the backup version of getRoisFromUser
%Changes: -move operators to Roi class
%           -allow user to spec what type of input (logical mask, point and
%           click) 
%           -Move completeley to ContourComponent; probably should finish
%           the class that creates the contours first.
%           -Modify RoiList and Roi so that they can take figure handles as
%           input
%           -Allow inperpolation between point and click points
%           -Allow getRoiAvgs & StDevs to accept an array of pointers to
%           images

classdef RoiList

methods
    zvals = getRoiAvgs(obj,img)
    xvals = getRowVals(obj)
    yvals = getColVals(obj)
    stdev = getRoiStDevs(obj,img)
    patchRois(obj,varargin)
    obj = getRoisFromUser(obj,image,h_instruction)
    roi_sizes = getRoiSizes(obj,varargin)
    surface = rois2Surface(obj)
    obj = and(obj_pre,obj_post)
    obj = minus(obj_pre,obj_post)
    outlineRois(obj,varargin)
    obj = calcOutlines(obj)
    
    function obj = RoiList(varargin)
        invar = struct('input_type','point and click','window',0);
        argin = varargin;
        invar = generateArgin(invar,argin);
        obj.length = 0;
        obj.rois = Roi();
        if strcmp(invar.input_type,'point and click') || size(varargin,2) == 1
            obj = obj.getRoisFromUser(varargin);
            obj = obj.calcOutlines();
        elseif strcmp(invar.input_type,'masks') %
            roi_images = varargin{1};
            for roi_count = 1:size(roi_images,3)
                roi_image = reshape(roi_images(:,:,roi_count),size(roi_images,1),size(roi_images,2));
                NEW_ROI = Roi(roi_image,'input_type','masks');
                obj.length = obj.length + 1;
                obj = obj.addRoi(NEW_ROI);
                clear NEW_ROI;
            end
            obj = obj.calcOutlines();
        else
            error('invalid input type: ''masks'' or point and click''')
        end
            
            
%         if size(varargin{1},3) == 1
%             obj = obj.getRoisFromUser(varargin);
%             obj = obj.calcOutlines(); %If ROIs are point and click specified, calculate their outlines
%         elseif size(varargin{1},3) > 1 %dimensions: (N,row,col)
%             roi_images = varargin{1};
%             for roi_count = 1:size(roi_images,1)
%                 roi_image = reshape(roi_images(roi_count,:,:),size(roi_images,2),size(roi_images,3));
%                 NEW_ROI = Roi(roi_image);
%                 obj.length = obj.length + 1;
%                 obj = obj.addRoi(NEW_ROI);
%                 clear NEW_ROI;
%             end
%         end
    end
    function obj = addRoi(obj,new_ROI) %adds ROI and returns size of new list
%         obj.length = obj.length + 1;
        obj.rois(obj.length) = new_ROI;
    end

%     function obj = and(obj_pre,obj_post)
%         keyboard;
%     end
    function ROI_list = getRois(obj)
        ROI_list = obj.rois;
    end %%getRois
    function value = getLength(obj)
        value = obj.length;
    end
    function roi = getSpecRoi(obj,index)
        roi = obj.rois(index);
    end
    function setLength(obj,new_length)
        obj.length = new_length;
    end
end        

    
properties (Access = private)
    length;
    rois;
    contours;
    iso_lines;
%     image;
end
    
end
