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

classdef Rois < dynamicprops

    methods
        zvals = getRoiAvgs(obj,varargin)
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
        num_pix = getNumPix(obj)
        new_obj = resizeRois(obj,factor)
        masks = getMasks(obj)
        obj = clickCallback(src,eventdata)
        roi = getSpecRoi(obj,varargin)
        obj = addRoi(obj,new_ROI)
        values = getGroupAvgs(obj,varargin)
        obj = saveRois(obj,source,varargin)
        varargout = loadRois(obj,source)
    end

    methods %other files
        function obj = Rois(varargin)
            invar = struct('input_type','point and click','window',0);
            argin = varargin;
            invar = generateArgin(invar,argin);
            if size(varargin,2) == 0
                obj.length = 0;
                obj.rois = Roi.empty(1,0);
                obj.contours = ContourComponent.empty(1,0);
            elseif strcmp(invar.input_type,'point and click') || size(varargin,2) == 1
                obj.rois = Roi();
                obj.length = 1;
                image = varargin{1};
                obj.addprop('f_h');
                h_click = {@clickCallback,obj,size(image)};
                f_h = figure;
                ID1 = iptaddcallback(f_h,'WindowButtonDownFcn',h_click);
                h_click_done = {@clickDoneCallback,ID1};
                ID2 = iptaddcallback(f_h,'WindowButtonDownFcn',h_click_done);
                h_close = {@closeRoisWindow,obj};
                ID3 = iptaddcallback(f_h,'CloseRequestFcn',h_close);
                if invar.window == 0
                    imagesc(image);
                else 
                    imagesc(image,invar.window);
                end
                axis image
                axis off
                colormap bone
            elseif strcmp(invar.input_type,'masks') %
                roi_images = varargin{1};
                obj.length = 0;
                if size(roi_images,3) == 1
                    obj.rois = Roi(roi_images,'input_type','masks');
                    obj.length = 1;
                else
                    obj.rois = Roi.empty(size(roi_images,1),0);
                    for roi_count = 1:size(roi_images,1)
                        roi_image = reshape(roi_images(roi_count,:,:),size(roi_images,2),size(roi_images,3));
                        NEW_ROI = Roi(roi_image,'input_type','masks');
                        obj = obj.addRoi(NEW_ROI);
                        clear NEW_ROI;
                    end
                end
            else
                error('invalid input type: ''masks'' or point and click''')
            end
        end
%         function obj = addRoi(obj,new_ROI) %adds ROI and returns size of new list
%             obj.length = obj.length + 1;
%             obj.rois(obj.length) = new_ROI;
%         end
        function ROI_list = getRois(obj)
            ROI_list = obj.rois;
        end %%getRois
        function value = getLength(obj)
            value = obj.length;
        end
%         function roi = getSpecRoi(obj,index)
%             roi = obj.rois(index);
%         end
        function setLength(obj,new_length)
            obj.length = new_length;
        end
        function obj = deleteRoi(obj,roi_num)
            obj.length = obj.length - 1;
            temp = Roi.empty(obj.length,0);
            temp(1:roi_num - 1) = obj.rois(1:roi_num - 1);
            if roi_num < max(size(obj.rois))
                temp(roi_num:obj.length) = obj.rois(roi_num + 1:obj.length + 1);
            end
            
            clear obj.rois;
            obj.rois = temp;
        end
    end        
    properties (Access = private)
        image_pc;
        length;
        rois;
        contours;  
    end
    
end