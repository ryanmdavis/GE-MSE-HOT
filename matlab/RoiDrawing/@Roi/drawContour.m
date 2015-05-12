function drawContour(obj,varargin)
    invar = struct('axes_h',gca,'width',1,'color',[],'style','-','f_h',gcf,'contour_num',1,'shift',[0 0],'scale',1);
    argin = varargin;
    invar = generateArgin(invar,argin);
    
    colors = {'y','m','c','r','g','b','w','k'};
    styles = {'-','--',':','-.'};
    
    if ~isempty(obj.group) && sum(strcmp(obj.group(invar.contour_num,1),colors)) == 1 && isempty(invar.color)
        invar.color = obj.group(invar.contour_num,1);
    elseif ~isempty(obj.group) && sum(strcmp(obj.group(invar.contour_num,1),colors)) ~= 0 && isempty(invar.color)
        warning('Roi_drawContour:grNoRec',['group is not recognized.  Group: ' obj.group(invar.contour_num,1)]);
    end
    
    if ~isempty(obj.group) && sum(sum(strcmp(obj.group(invar.contour_num,2:end),styles)) == [1 2]) == 1
        invar.style = obj.group(invar.contour_num,2:end);
    elseif ~isempty(obj.group) && sum(strcmp(obj.group(invar.contour_num,2:end),colors)) ~= 0
        warning('Roi_drawContour:grNoRec',['group is not recognized.  Group: ' obj.group(invar.contour_num,2:end)]);
    end
    
    obj.contour(invar.contour_num).drawContour('axes_h',invar.axes_h,'width',invar.width,'color',invar.color,'style',invar.style,'f_h',invar.f_h,'shift',invar.shift,'scale',invar.scale);