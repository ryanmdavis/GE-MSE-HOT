%patch

classdef Roi < handle
    methods %other files
        map = getMask(obj,varargin)
        obj = drawContour(obj,varargin)
        values = averages(obj,varargin)
    end
    methods
        [centroid,num_pix] = findCentroid(obj);
        function obj = Roi(varargin)
            invar = struct('input_type','point and click','window',0,'contour_points',[]);
            argin = varargin;
            invar = generateArgin(invar,argin);
            if size(varargin,2) ~= 0
                if strcmp(invar.input_type,'masks') %if the image is an ROI
                    obj.mask = varargin{1};
                    obj.xi = 0;
                    obj.yi = 0;
                elseif strcmp(invar.input_type,'point and click')
                    image = varargin{1};
                    obj.mask = zeros(size(image));
%                     obj.mask = poly2mask(xi,yi,size(image,1),size(image,2))';
                elseif strcmp(invar.input_type,'handle')
                    axes(varargin{1})
                    [obj.mask,obj.xi,obj.yi] = roipoly;
                end % if: what input type
                if isempty(invar.contour_points)
                    obj.contour = ContourComponent(obj.mask);  
                else
                    obj.contour = ContourComponent(obj.mask,'outline_type',invar.contour_points);
                end
                obj.xi=obj.contour.getColPts;
                obj.yi=obj.contour.getRowPts;
                [obj.centroid,obj.num_pix] = obj.findCentroid();
            else %if inputs
                obj.mask = 0;           
                obj.centroid = 0;
                obj.num_pix = 0;
                obj.contour = ContourComponent.empty(1,0);
                obj.xi = [];
                obj.yi = [];
            end %if inputs
        end %%constructor
        function value = getCentroid(obj)
            value = obj.centroid;
        end
        function value = getNumPix(obj)
            value = obj.num_pix;
        end
        function [xi_return,yi_return] = getRoiPoints(obj)
            xi_return = obj.xi;
            yi_return = obj.yi;
        end
        function obj = setMask(obj,new_mask)
            obj.mask = boolean(new_mask);
        end
        function vals = getX(obj)
            vals = obj.xi;
        end
        function vals = getY(obj)
            vals = obj.yi;
        end
        function obj = refreshProperties(obj)
            [centroid,num_pix] = obj.findCentroid();
            obj.num_pix = num_pix;
            obj.centroid = centroid;
            obj.contour = ContourComponent(obj.mask);
        end
        function val = getContour(obj)
            val = obj.contour;
        end
        function obj = addPoint(obj,points)
            obj.xi(size(obj.xi,2)+1) = points(1,2);
            obj.yi(size(obj.yi,2)+1) = points(1,1);
        end
        function obj = setGroup(obj,new_group)
            obj.group = new_group;
        end
        function val = getGroup(obj)
            val = obj.group;
        end
  
    end %methods
        
    properties (Access = private)
        xi;
        yi;
        mask;
        centroid;
        num_pix;
        contour;
        group;
    end %properties
end%Roi    