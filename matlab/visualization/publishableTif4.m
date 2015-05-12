%final argument: 0 - no margins (i.e. an image with no axis labels)
%               1 - left and bottom margins, i.e. with axis labels
%               2 - right margin for colorbar

function publishableTif4(f_h,path,size_inch,varargin)

if nargin==4
    margins=varargin{1};
else
    margins=1;
end

set(f_h,'units','inches');
set(f_h,'Position',[1 1 size_inch(1) size_inch(2)]);
% set(f_h,'PaperSize',[size_inch(1) size_inch(2)]);
set(f_h,'color','w');
set(gca,'units','inches');
if margins == 1
    set(gca,'position',[size_inch(1)/4 size_inch(1)/4 size_inch(1)*4/6 size_inch(2)*4/6]);
elseif margins == 0
    set(gca,'position',[0 0 size_inch(1) size_inch(2)]);
elseif margins == 2
    set(gca,'position',[0 size_inch(2)*0.1 size_inch(1)/2 size_inch(2)*0.8]);
end
set(gcf,'PaperType','usletter');
set(gcf,'PaperOrientation','portrait');
drawnow
print(f_h,path,'-dtiff','-r300');