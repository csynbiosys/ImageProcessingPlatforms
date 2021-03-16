function varargout = InducersInfo(varargin)
% INDUCERSINFO MATLAB code for InducersInfo.fig
%      INDUCERSINFO, by itself, creates a new INDUCERSINFO or raises the existing
%      singleton*.
%
%      H = INDUCERSINFO returns the handle to a new INDUCERSINFO or the handle to
%      the existing singleton*.
%
%      INDUCERSINFO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INDUCERSINFO.M with the given input arguments.
%
%      INDUCERSINFO('Property','Value',...) creates a new INDUCERSINFO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before InducersInfo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to InducersInfo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help InducersInfo

% Last Modified by GUIDE v2.5 02-Mar-2020 12:34:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @InducersInfo_OpeningFcn, ...
                   'gui_OutputFcn',  @InducersInfo_OutputFcn, ...
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


% --- Executes just before InducersInfo is made visible.
function InducersInfo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to InducersInfo (see VARARGIN)

% Choose default command line output for InducersInfo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes InducersInfo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = InducersInfo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in Inducer1.
function Inducer1_Callback(hObject, eventdata, handles)
% hObject    handle to Inducer1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Inducer1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Inducer1


% --- Executes during object creation, after setting all properties.
function Inducer1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Inducer1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SIYes.
function SIYes_Callback(hObject, eventdata, handles)
% hObject    handle to SIYes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.SIYes.Value == 1
    handles.SIYes.BackgroundColor = [0.3922 0.8314 0.0745];
    handles.SINo.BackgroundColor = [0.9400 0.9400 0.9400];
    handles.SINo.Value = 0;
elseif handles.SIYes.Value == 0
    handles.SIYes.BackgroundColor = [0.9400 0.9400 0.9400];
end
% Hint: get(hObject,'Value') returns toggle state of SIYes


% --- Executes on button press in SINo.
function SINo_Callback(hObject, eventdata, handles)
% hObject    handle to SINo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.SINo.Value == 1
    handles.SINo.BackgroundColor = [0.3922 0.8314 0.0745];
    handles.SIYes.BackgroundColor = [0.9400 0.9400 0.9400];
    handles.SIYes.Value = 0;
elseif handles.SINo.Value == 0
    handles.SINo.BackgroundColor = [0.9400 0.9400 0.9400];
end
% Hint: get(hObject,'Value') returns toggle state of SINo


% --- Executes on selection change in Inducer2.
function Inducer2_Callback(hObject, eventdata, handles)
% hObject    handle to Inducer2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Inducer2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Inducer2


% --- Executes during object creation, after setting all properties.
function Inducer2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Inducer2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SIConstant.
function SIConstant_Callback(hObject, eventdata, handles)
% hObject    handle to SIConstant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.SIConstant.Value == 1
    handles.SIConstant.BackgroundColor = [0.3922 0.8314 0.0745];
    handles.SIComplementary.BackgroundColor = [0.9400 0.9400 0.9400];
    handles.SIComplementary.Value = 0;
elseif handles.SIConstant.Value == 0
    handles.SIConstant.BackgroundColor = [0.9400 0.9400 0.9400];
end

% Hint: get(hObject,'Value') returns toggle state of SIConstant


% --- Executes on button press in SIComplementary.
function SIComplementary_Callback(hObject, eventdata, handles)
% hObject    handle to SIComplementary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.SIComplementary.Value == 1
    handles.SIComplementary.BackgroundColor = [0.3922 0.8314 0.0745];
    handles.SIConstant.BackgroundColor = [0.9400 0.9400 0.9400];
    handles.SIConstant.Value = 0;
elseif handles.SIComplementary.Value == 0
    handles.SIComplementary.BackgroundColor = [0.9400 0.9400 0.9400];
end
% Hint: get(hObject,'Value') returns toggle state of SIComplementary



function SIConcentration_Callback(hObject, eventdata, handles)
% hObject    handle to SIConcentration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SIConcentration as text
%        str2double(get(hObject,'String')) returns contents of SIConcentration as a double


% --- Executes during object creation, after setting all properties.
function SIConcentration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SIConcentration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SIUnits_Callback(hObject, eventdata, handles)
% hObject    handle to SIUnits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SIUnits as text
%        str2double(get(hObject,'String')) returns contents of SIUnits as a double


% --- Executes during object creation, after setting all properties.
function SIUnits_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SIUnits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function UnitsInducer1_Callback(hObject, eventdata, handles)
% hObject    handle to UnitsInducer1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UnitsInducer1 as text
%        str2double(get(hObject,'String')) returns contents of UnitsInducer1 as a double


% --- Executes during object creation, after setting all properties.
function UnitsInducer1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UnitsInducer1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Finish.
function Finish_Callback(hObject, eventdata, handles)
% hObject    handle to Finish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


IndInf.Inducer1 = handles.Inducer1.String{handles.Inducer1.Value};
IndInf.Ind1Unit = handles.UnitsInducer1.String;
IndInf.ON1 = str2double(handles.ON1.String);
if handles.SIYes.Value == 1
    IndInf.Inducer2 = handles.Inducer2.String{handles.Inducer2.Value};
    if handles.SIComplementary.Value==1
        IndInf.Ind2Type = handles.SIComplementary.String;
    else
        IndInf.Ind2Type = handles.SIConstant.String;
    end
    IndInf.Ind2Con = str2double(handles.SIConcentration.String);
    IndInf.Ind2Unit = handles.SIUnits.String;
    IndInf.ON2 = str2double(handles.ON2.String);
else
    IndInf.Inducer2 = '';
    IndInf.Ind2Type = '';
    IndInf.Ind2Con = [];
    IndInf.Ind2Unit = '';
    IndInf.ON2 = [];
end

% save the updated structure
save('TempFileInputs.mat', 'IndInf');
close

% handles



function ON1_Callback(hObject, eventdata, handles)
% hObject    handle to ON1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ON1 as text
%        str2double(get(hObject,'String')) returns contents of ON1 as a double


% --- Executes during object creation, after setting all properties.
function ON1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ON1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ON2_Callback(hObject, eventdata, handles)
% hObject    handle to ON2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ON2 as text
%        str2double(get(hObject,'String')) returns contents of ON2 as a double


% --- Executes during object creation, after setting all properties.
function ON2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ON2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
