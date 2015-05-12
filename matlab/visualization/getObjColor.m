function varargout = getObjColor(obj_num)
style_num = floor(obj_num/8);
switch(mod(obj_num,7))
    case 1
        varargout{1} = 'b';
    case 2
        varargout{1} = 'g';
    case 3
        varargout{1} = 'r';
    case 4
        varargout{1} = 'c';
    case 5
        varargout{1} = 'm';
    case 6
        varargout{1} = 'y';
    case 0
        varargout{1} = 'k';
%     otherwise
%         varargout{1} = 'k';
end

if nargout == 2
    switch style_num
        case 0
            varargout{2} = '-';
        case 1
            varargout{2} = '--';
        case 2
            varargout{2} = '-.';
    end
end