function centeredTextOnPlot(center_x,bottom_y,text_)

dollar_signs=strfind(text_,'$');
if ~(size(dollar_signs,2)==2)
    text_=strcat('$',text_,'$');
end

% if interpreter_flag == 1
text_h=text(center_x,bottom_y,text_,'Interpreter','LaTex');
% else
%     text_h=text(center_x,bottom_y,text_);    
% end
extent=get(text_h,'Extent');
position=get(text_h,'Position');
position(1)=position(1)-extent(3)/2;
set(text_h,'Position',position);