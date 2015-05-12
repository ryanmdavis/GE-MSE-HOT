function clickCallback(src,eventData,obj,image_size)
    point_data = get(gca,'CurrentPoint');
    obj.getSpecRoi(obj.getLength).addPoint(point_data(1,1:2));
    [xi,yi] = obj.getSpecRoi(obj.getLength).getRoiPoints;
    line(yi,xi,'color',getObjColor(obj.getLength));

    if size(xi,2) ~= 1 && strcmp(get(gcf,'SelectionType'),'alt')
        obj.getSpecRoi(obj.getLength).setMask(poly2mask(yi,xi,image_size(1),image_size(2)));
        obj.getSpecRoi(obj.getLength).refreshProperties;
        obj.getSpecRoi(obj.getLength).addPoint([yi(1) xi(1)]);
        [xi,yi] = obj.getSpecRoi(obj.getLength).getRoiPoints;
        line(yi,xi,'color',getObjColor(obj.getLength));
        obj.addRoi(Roi());
    end

        
end