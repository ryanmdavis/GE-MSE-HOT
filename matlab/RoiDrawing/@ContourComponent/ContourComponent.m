classdef ContourComponent
    properties (Access = private)
        row_points;
        col_points;
        component_start_position;
        image_contour;
        mask;
        outline_type
    end %properties
    
    methods %other files
        istrue = is2dim(obj)
        [row_points,col_points,component_start_position] = findContour(obj,contour,varargin)
        isclosed = isContourClosed(obj)
        drawContour(obj,varargin) %change this to drawContour(...) because you don't need two function
        outlineContour(obj,varargin) %%% ditto
    end
    
    methods
        function obj = ContourComponent(mask,varargin) %constructor
            invar = struct('outline_type','inline');
            argin = varargin;
            invar = generateArgin(invar,argin);
            obj.component_start_position=[];
            if ischar(invar.outline_type)
                obj.outline_type = invar.outline_type;
                obj.mask = mask;
                SE = strel('disk',1,0);
                obj.image_contour = mask - imerode(mask,SE);
                [obj.row_points,obj.col_points,obj.component_start_position] = obj.findContour(obj.image_contour,'outline_type',invar.outline_type);
            else
                obj.row_points = invar.outline_type(:,1);
                obj.col_points = invar.outline_type(:,2);
                obj.component_start_position=[1 size(obj.row_points,1)];
            end

        end %constructor
        function val = getRowPts(obj)
            val = obj.row_points;
        end
        function val = getColPts(obj)
            val = obj.col_points;
        end
    end
end    
% [obj.row_points,obj.col_points] = obj.findContour(varargin);