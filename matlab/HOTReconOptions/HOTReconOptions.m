function varargout = HOTReconOptions(varargin)
% HOTRECONOPTIONS MATLAB code for HOTReconOptions.fig
%      HOTRECONOPTIONS, by itself, creates a new HOTRECONOPTIONS or raises the existing
%      singleton*.
%
%      H = HOTRECONOPTIONS returns the handle to a new HOTRECONOPTIONS or the handle to
%      the existing singleton*.
%
%      HOTRECONOPTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HOTRECONOPTIONS.M with the given input arguments.
%
%      HOTRECONOPTIONS('Property','Value',...) creates a new HOTRECONOPTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HOTReconOptions_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HOTReconOptions_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HOTReconOptions

% Last Modified by GUIDE v2.5 24-Apr-2015 15:51:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HOTReconOptions_OpeningFcn, ...
                   'gui_OutputFcn',  @HOTReconOptions_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before HOTReconOptions is made visible.
function HOTReconOptions_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HOTReconOptions (see VARARGIN)

% Choose default command line output for HOTReconOptions
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% populate all of the GUI entries
populateGUIEntries(handles);

% UIWAIT makes HOTReconOptions wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HOTReconOptions_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

setHOTReconOption('num_echoes_avg',str2num(get(hObject,'String')));
    
% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

    % reconstruct as an image (fermi filtered) or 2D spectrum (no filtering)
% data_type=getHOTReconOption('data_type');
if get(handles.popupmenu1,'Value') == 1
    setHOTReconOption('data_type','2D spectra');
elseif get(handles.popupmenu1,'Value') == 2
    setHOTReconOption('data_type','images');
else
    warning(cell2str(strcat({'"',data_type,'" is an invalid value for option "data_type"'})));
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function populateGUIEntries(handles)
    % which echoes to average
    set(handles.edit1,'String',num2str(getHOTReconOption('num_echoes_avg')));
    
    % reconstruct as an image (fermi filtered) or 2D spectrum (no filtering)
    data_type=getHOTReconOption('data_type');
    if strcmp(data_type,'2D spectra')
        set(handles.popupmenu1,'Value',1);
    elseif strcmp(data_type,'images')
        set(handles.popupmenu1,'Value',2);
    else
        warning(cell2str(strcat({'"',data_type,'" is an invalid value for option "data_type"'})))
    end
    
    % display data after recon
    display=getHOTReconOption('display');
    if display==1
        set(handles.popupmenu1,'Value',1);
    elseif display==0
        set(handles.popupmenu1,'Value',2);
    else
        warning(cell2str(strcat({'value of "display" must be 1 (on) or 0 (off)'})))
    end

    % recon size
    recon_size=getHOTReconOption('recon_size');
    set(handles.edit2,'String',num2str(2^nextpow2(recon_size)));
    
    % decomposition values
    decomposition=getHOTReconOption('decomposition');
    switch decomposition
        case 'off'          
            set(handles.popupmenu4,'value',1);
            set(handles.edit3,'Enable','off');
        case 'calculate'    
            set(handles.popupmenu4,'value',2);
            set(handles.edit3,'Enable','on');
        case 'use saved'    
            set(handles.popupmenu4,'value',3);
            set(handles.edit3,'Enable','off');
    end
    
    % scan number for decomposition
    decomposition_scan=getHOTReconOption('decomposition_scan');
    set(handles.edit3,'String',num2str(decomposition_scan));

    % fermi filtering
    fermi_E=getHOTReconOption('fermi_E');
    fermi_T=getHOTReconOption('fermi_T');
    set(handles.edit6,'String',num2str(fermi_E));
    set(handles.edit5,'String',num2str(fermi_T));
    
    % shift images
    row_shift=getHOTReconOption('row_shift');
    col_shift=getHOTReconOption('col_shift');
    set(handles.edit7,'String',row_shift);
    set(handles.edit8,'String',col_shift);
    
% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
if get(handles.popupmenu2,'Value') == 1
    setHOTReconOption('display',1);
elseif get(handles.popupmenu2,'Value') == 2
    setHOTReconOption('display',0);
else
    warning(cell2str(strcat({'value of "display" must be 1 (on) or 0 (off)'})))
end

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

recon_size=str2double(get(handles.edit2,'String'));
set(handles.edit2,'String',num2str(2^nextpow2(recon_size)));
setHOTReconOption('recon_size',2^nextpow2(recon_size));

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4

decomposition = get(handles.popupmenu4,'value');
switch decomposition
    case 1
        setHOTReconOption('decomposition','off');
        set(handles.edit3,'Enable','off');
    case 2
        setHOTReconOption('decomposition','calculate');
        set(handles.edit3,'Enable','on');
    case 3
        setHOTReconOption('decomposition','use saved');
        set(handles.edit3,'Enable','off');
end

% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double

value=setHOTReconOption_checkValue('decomposition_scan',get(handles.edit3,'String'));

if ~isempty(value)
    setHOTReconOption('decomposition_scan',value);
else
    set(handles.edit3,'String','Value must be a positive integer');
end

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

    



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double

fermi_T=str2double(get(handles.edit5,'String'));
setHOTReconOption('fermi_T',fermi_T);

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double

fermi_E=str2double(get(handles.edit6,'String'));
setHOTReconOption('fermi_E',fermi_E);
% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4
setHOTReconOption('weight_iZQC',get(hObject,'Value'));



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
setHOTReconOption('row_shift',str2double(get(hObject,'String')))

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
setHOTReconOption('col_shift',str2double(get(hObject,'String')))

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
