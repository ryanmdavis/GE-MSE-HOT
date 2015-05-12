%patch

classdef Roi
    methods
        [centroid,num_pix] = findCentroid(obj);
        function obj = Roi(varargin)
%             invar = struct('input_type','point and click');
%             argin = varargin;
%             invar = generateArgin(invar,argin);
            if size(varargin,2) == 1
                if max(max(varargin{1})) == 1 && min(min(varargin{1})) == 0 %if the image is an ROI
                    obj.mask = varargin{1};
                    obj.xi = 0;
                    obj.yi = 0;
                else %if the image is a image, its max val is probably not identical to one
                    image = varargin{1};
                    imagesc(image);
                    axis image
                    axis off
                    [obj.mask,obj.xi,obj.yi] = roipoly;
                end
                [obj.centroid,obj.num_pix] = obj.findCentroid();
            elseif size(varargin,2) == 2
                image = varargin{1};
                LIST = varargin{2}; %I pass this so you can patch the rest
                imagesc(image);     
                axis image
                axis off
                LIST.patchRois;
                [obj.mask,obj.xi,obj.yi] = roipoly;
                [obj.centroid,obj.num_pix] = obj.findCentroid();               
            elseif size(varargin,2) == 0
                obj.mask = 0;
                obj.centroid = 0;
                obj.num_pix = 0;
            end
        end %%constructor
        function value = getMask(obj)
            value = obj.mask;
        end
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
        function obj = refreshProperties(obj)
            [centroid,num_pix] = obj.findCentroid();
            obj.num_pix = num_pix;
            obj.centroid = centroid;
        end
    end %methods
                
        
        
        
    properties (Access = private)
        xi;
        yi;
        mask;
        centroid;
        num_pix;
    end %properties
end%Roi    