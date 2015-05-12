function fieldss = getGeHdrEntry(file,fieldss)

text_temp = textread(file,'%s');
text = '';
for cell_num = 1:size(text_temp,1)
    text = [text text_temp{cell_num} ' '];
end

fields = fieldnames(fieldss);
for field_num = 1:size(fields,1);
    field = fields{field_num};
    dash_loc=strfind(field,'_d_');
    if ~isempty(dash_loc)
        field=strcat(field(1:(dash_loc-1)),'-',field((dash_loc+3):end));
    end
    field(strfind(field,'_d_')) = '-';
    field(strfind(field,'_')) = ' ';
    field_size = size(field,2);
    location = min(strfind(text,field)) + field_size;
    if ~isempty(location)
        begin_loc = location + min(strfind(text(location:end),': '))+1; %two for delimiter (##) and one for a space
        end_loc = location + min(strfind(text(location:end),'...'))+1;

        value = str2double(text(begin_loc:end_loc-4));

        if isempty(value)||isnan(value)
            value = text(begin_loc:end_loc-4);
        end
        fieldss.(fields{field_num}) = value;
    end
end