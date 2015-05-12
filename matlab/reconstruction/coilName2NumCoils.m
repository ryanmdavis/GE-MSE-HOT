function num_coils = coilName2NumCoils(coil_name_str)
switch coil_name_str
    case 'HEAD'
        num_coils = 1;
    case {'8HRBRAIN','HD TR Knee PA','HD Cardiac'}
        num_coils = 8;
    case 'GEM Flex LG Full'
        num_coils = 16;
    case 'HD Wrist Array'
        num_coils = 8;
    otherwise
        num_coils = 1;
end