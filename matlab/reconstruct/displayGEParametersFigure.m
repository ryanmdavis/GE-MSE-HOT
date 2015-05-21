function displayGEParametersFigure(directory)

fields = struct('variable_37',0,'variable_38',0,'variable_39',0,'variable_40',0,'variable_41',0,'variable_42',0,'variable_43',0,'variable_44',0,'variable_45',0,'variable_46',0,'variable_47',0,'variable_48',0,'Last_series_number_used',0,'PS_MPS_R1',0,'PS_MPS_R2',0,'PS_MPS_transmit',0,'PS_MPS_center',0,'Display_field_of_view__d__x',0,'Display_field_of_view__d__y',0,'Scan_time',0,'center_coordinate_of_image',0);
fields = getGeHdrEntry(strcat(directory,'_header.txt'),fields);
field_names=fieldnames(fields);
names={bufstr('recon type'),bufstr('time_bw_rfc_pulses'),bufstr('opte'),bufstr('oprbw (x1000)'),bufstr('oprbw2 (x1000)'),bufstr('spect_flag'),bufstr('opnecho'),bufstr('sel_rfc_offset_hz'),bufstr('sel_exc_offset_hz'),bufstr('t1'),bufstr('tau'),bufstr('tau_max'),bufstr('Scan #'),bufstr('R1'),bufstr('R2'),bufstr('TG'),bufstr('BF'),bufstr('FOVx'),bufstr('FOVy'),bufstr('Scan Time:')};

%% create and position text box figure
f_h=figure;
set(f_h,'Units','normalized')
set(f_h,'Position',[0.2 0.2 0.5 0.5]);
tb_h=uicontrol('style','text');
set(tb_h,'Units','Normalized');
set(tb_h,'Position',[0.1 0.1 0.8 0.8]);
set(tb_h,'HorizontalAlignment','left');

% display(' ');
display_cell{1}=cell2str(strcat({expName(directory)},{': Scan #'},{num2str(fields.Last_series_number_used)}));
for field_num=1:size(names,2)
    display_cell{1+field_num}=cell2str(strcat({bufstr(names{field_num})},{num2str(fields.(field_names{field_num}))}));
%     display(display_cell{1});
end


% display path
display_cell{1+size(names,2)+1}=cell2str(strcat({bufstr('path')},{directory}));

% display time (sec)
display_cell{1+size(names,2)+2}=cell2str(strcat({bufstr('Scan timestamp (sec)')},{num2str(time2sec(fields.Scan_time))}));

% display image location
display_cell{1+size(names,2)+3}=cell2str(strcat({bufstr('(R,A,S) Img. cent. (mm):')},{fields.center_coordinate_of_image}));

set(tb_h,'String',display_cell);
end
    
function bs=bufstr(str)
string_size=30;
bs(1:string_size)=' ';
bs(1:size(str,2))=str;
end

function exp_name = expName(directory)
slash=strfind(directory,'\');
exp_name=directory(slash(end-1)+1:slash(end)-1);
end