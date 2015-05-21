%input can be datetime or just time
function sec=time2sec(datetime)

if ~(size(datetime,2)==8 || size(datetime,2)==5)
    error('format must be ''hh:mm:ss'' or ''hh:mm''');
end

colon_loc = strfind(datetime,':');
time_min  = str2double(datetime(colon_loc(1)+1:colon_loc(1)+2));
time_hour = str2double(datetime(colon_loc(1)-2:colon_loc(1)-1));
if size(colon_loc,2) == 2
    time_sec = str2double(datetime(colon_loc(2)+1:colon_loc(2)+2));
else
    time_sec = 0;
end
sec=time_sec+time_min*60+time_hour*60^2; %in seconds since 00:00:00 of today