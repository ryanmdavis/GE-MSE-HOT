function i_rgb=intensity2RGB(im,colormap,varargin)

if nargin==2
    range=[0 1];
    im=im/max(max(abs(im)));
else
    range=varargin{1};
end

im=squeeze(im);
% im(im<range(1)*min(min(im)))=range(1)*min(min(im));
% im(im>range(2)*max(max(im)))=range(2)*max(max(im));

im(im<range(1))=range(1);
im(im>range(2))=range(2);

im=im-range(1);

im=int8((size(colormap,1)-1)*im/(range(2)-range(1)))+1;
i_rgb=zeros([size(im) 3]);

for row=1:size(im,1)
    for col=1:size(im,2)
        i_rgb(row,col,:)=colormap(im(row,col),:);
    end
end