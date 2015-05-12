function value=setHOTReconOption_checkValue(option,value)

switch option
    case 'decomposition'
        if ~(strcmp(value,'off') || strcmp(value,'calculate') || strcmp(value,'use saved'))
            warning(cell2str(strcat({value},{' is not a valid value for option '},{option})));
            value=[];
        end
    case 'decomposition_scan'
        if isa(value,'double') value=num2str(value);  %#ok<SEPEX>
        elseif isempty(str2double(value)) value = [];%#ok<SEPEX>
        elseif str2double(value)<1 value = []; %#ok<SEPEX>
        end
end