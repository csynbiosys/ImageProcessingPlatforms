function varargout = StartMainGUI_Unif(varargin)
% STARTMAINGUI_UNIF MATLAB code for StartMainGUI_Unif.fig
%      STARTMAINGUI_UNIF, by itself, creates a new STARTMAINGUI_UNIF or raises the existing
%      singleton*.
%
%      H = STARTMAINGUI_UNIF returns the handle to a new STARTMAINGUI_UNIF or the handle to
%      the existing singleton*.
%
%      STARTMAINGUI_UNIF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STARTMAINGUI_UNIF.M with the given input arguments.
%
%      STARTMAINGUI_UNIF('Property','Value',...) creates a new STARTMAINGUI_UNIF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before StartMainGUI_Unif_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to StartMainGUI_Unif_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help StartMainGUI_Unif

% Last Modified by GUIDE v2.5 10-Mar-2021 18:14:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @StartMainGUI_Unif_OpeningFcn, ...
                   'gui_OutputFcn',  @StartMainGUI_Unif_OutputFcn, ...
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


% --- Executes just before StartMainGUI_Unif is made visible.
function StartMainGUI_Unif_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to StartMainGUI_Unif (see VARARGIN)

% Choose default command line output for StartMainGUI_Unif
handles.output = hObject;
addpath('FunctionsOnLine');
addpath('Miscelaneous');
handles.Device = '';

% s = imread(['Miscelaneous\bacteria.jpg']);
% imshow(mat2gray(s));
% Update handles structure
guidata(hObject, handles);


% UIWAIT makes StartMainGUI_Unif wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = StartMainGUI_Unif_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function Identifier_Callback(hObject, eventdata, handles)
% hObject    handle to Identifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Identifier as text
%        str2double(get(hObject,'String')) returns contents of Identifier as a double


% --- Executes during object creation, after setting all properties.
function Identifier_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Identifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ExperimentDirectory.
function ExperimentDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to ExperimentDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


cells = [handles.Dir1, handles.Dir2, handles.Dir3, handles.Dir4, handles.Dir5, handles.Dir6,...
    handles.Dir7, handles.Dir8, handles.Dir9, handles.Dir10, handles.Dir11, handles.Dir12, handles.Dir13,...
    handles.Dir14, handles.Dir15, handles.Dir16, handles.Dir17, handles.Dir18, handles.Dir19, handles.Dir20];
backs = [handles.Back1, handles.Back2, handles.Back3, handles.Back4, handles.Back5, handles.Back6,...
    handles.Back7, handles.Back8, handles.Back9, handles.Back10, handles.Back11, handles.Back12, handles.Back13,...
    handles.Back14, handles.Back15, handles.Back16, handles.Back17, handles.Back18, handles.Back19, handles.Back20];

% Get directories stored
for i = 1:20
    cells(i).String = '';
    cells(i).Value = 0;
    cells(i).BackgroundColor = [0.94 0.94 0.94];
    cells(i).ForegroundColor = [0 0 0];
    backs(i).String = '';
    backs(i).Value = 0;
    backs(i).BackgroundColor = [0.94 0.94 0.94];
    backs(i).ForegroundColor = [0 0 0];
end

% Get main directory of the experiment
try
    exps = load('D:\AcquisitionDataRiddler\ExptInfo.mat');
    dir1 = strrep(exps.dirs,'/','\');
    modelDir = uigetdir(dir1);
catch
    modelDir = uigetdir;
end
    
% modelDir = uigetdir;

handles.DispDir.String = modelDir;

% Get directories of all the positions of the experiment
files = dir(modelDir);
dirFlags = find([files.isdir] & ~strcmp({files.name},'.') & ~strcmp({files.name},'..'));

% Toggle 1 (Cell)
if ~isempty(dirFlags)
    handles.Dir1.String = files(dirFlags(1)).name;
end
% Toggle 2 (Cell)
if length(dirFlags) >= 2
    handles.Dir2.String = files(dirFlags(2)).name;
end
% Toggle 3 (Cell)
if length(dirFlags) >= 3
    handles.Dir3.String = files(dirFlags(3)).name;
end
% Toggle 4 (Cell)
if length(dirFlags) >= 4
    handles.Dir4.String = files(dirFlags(4)).name;
end
% Toggle 5 (Cell)
if length(dirFlags) >= 5
    handles.Dir5.String = files(dirFlags(5)).name;
end
% Toggle 6 (Cell)
if length(dirFlags) >= 6
    handles.Dir6.String = files(dirFlags(6)).name;
end
% Toggle 7 (Cell)
if length(dirFlags) >= 7
    handles.Dir7.String = files(dirFlags(7)).name;
end
% Toggle 8 (Cell)
if length(dirFlags) >= 8
    handles.Dir8.String = files(dirFlags(8)).name;
end
% Toggle 9 (Cell)
if length(dirFlags) >= 9
    handles.Dir9.String = files(dirFlags(9)).name;
end
% Toggle 10 (Cell)
if length(dirFlags) >= 10
    handles.Dir10.String = files(dirFlags(10)).name;
end
% Toggle 11 (Cell)
if length(dirFlags) >= 11
    handles.Dir11.String = files(dirFlags(11)).name;
end
% Toggle 12 (Cell)
if length(dirFlags) >= 12
    handles.Dir12.String = files(dirFlags(12)).name;
end
% Toggle 13 (Cell)
if length(dirFlags) >= 13
    handles.Dir13.String = files(dirFlags(13)).name;
end
% Toggle 14 (Cell)
if length(dirFlags) >= 14
    handles.Dir14.String = files(dirFlags(14)).name;
end
% Toggle 15 (Cell)
if length(dirFlags) >= 15
    handles.Dir15.String = files(dirFlags(15)).name;
end
% Toggle 16 (Cell)
if length(dirFlags) >= 16
    handles.Dir16.String = files(dirFlags(16)).name;
end
% Toggle 17 (Cell)
if length(dirFlags) >= 17
    handles.Dir17.String = files(dirFlags(17)).name;
end
% Toggle 18 (Cell)
if length(dirFlags) >= 18
    handles.Dir18.String = files(dirFlags(18)).name;
end
% Toggle 19 (Cell)
if length(dirFlags) >= 19
    handles.Dir19.String = files(dirFlags(19)).name;
end
% Toggle 20 (Cell)
if length(dirFlags) >= 20
    handles.Dir20.String = files(dirFlags(20)).name;
end


% Toggle 1 (Background)
if ~isempty(dirFlags)
    handles.Back1.String = files(dirFlags(1)).name;
end
% Toggle 2 (Background)
if length(dirFlags) >= 2
    handles.Back2.String = files(dirFlags(2)).name;
end
% Toggle 3 (Background)
if length(dirFlags) >= 3
    handles.Back3.String = files(dirFlags(3)).name;
end
% Toggle 4 (Background)
if length(dirFlags) >= 4
    handles.Back4.String = files(dirFlags(4)).name;
end
% Toggle 5 (Background)
if length(dirFlags) >= 5
    handles.Back5.String = files(dirFlags(5)).name;
end
% Toggle 6 (Background)
if length(dirFlags) >= 6
    handles.Back6.String = files(dirFlags(6)).name;
end
% Toggle 7 (Background)
if length(dirFlags) >= 7
    handles.Back7.String = files(dirFlags(7)).name;
end
% Toggle 8 (Background)
if length(dirFlags) >= 8
    handles.Back8.String = files(dirFlags(8)).name;
end
% Toggle 9 (Background)
if length(dirFlags) >= 9
    handles.Back9.String = files(dirFlags(9)).name;
end
% Toggle 10 (Background)
if length(dirFlags) >= 10
    handles.Back10.String = files(dirFlags(10)).name;
end
% Toggle 11 (Background)
if length(dirFlags) >= 11
    handles.Back11.String = files(dirFlags(11)).name;
end
% Toggle 12 (Background)
if length(dirFlags) >= 12
    handles.Back12.String = files(dirFlags(12)).name;
end
% Toggle 13 (Background)
if length(dirFlags) >= 13
    handles.Back13.String = files(dirFlags(13)).name;
end
% Toggle 14 (Background)
if length(dirFlags) >= 14
    handles.Back14.String = files(dirFlags(14)).name;
end
% Toggle 15 (Background)
if length(dirFlags) >= 15
    handles.Back15.String = files(dirFlags(15)).name;
end
% Toggle 16 (Background)
if length(dirFlags) >= 16
    handles.Back16.String = files(dirFlags(16)).name;
end
% Toggle 17 (Background)
if length(dirFlags) >= 17
    handles.Back17.String = files(dirFlags(17)).name;
end
% Toggle 18 (Background)
if length(dirFlags) >= 18
    handles.Back18.String = files(dirFlags(18)).name;
end
% Toggle 19 (Background)
if length(dirFlags) >= 19
    handles.Back19.String = files(dirFlags(19)).name;
end
% Toggle 20 (Background)
if length(dirFlags) >= 20
    handles.Back20.String = files(dirFlags(20)).name;
end



function DispDir_Callback(hObject, eventdata, handles)
% hObject    handle to DispDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

files = dir(handles.DispDir.String);
dirFlags = find([files.isdir] & ~strcmp({files.name},'.') & ~strcmp({files.name},'..'));

% Toggle 1 (Cell)
if ~isempty(dirFlags)
    handles.Dir1.String = files(dirFlags(1)).name;
end
% Toggle 2 (Cell)
if length(dirFlags) >= 2
    handles.Dir2.String = files(dirFlags(2)).name;
end
% Toggle 3 (Cell)
if length(dirFlags) >= 3
    handles.Dir3.String = files(dirFlags(3)).name;
end
% Toggle 4 (Cell)
if length(dirFlags) >= 4
    handles.Dir4.String = files(dirFlags(4)).name;
end
% Toggle 5 (Cell)
if length(dirFlags) >= 5
    handles.Dir5.String = files(dirFlags(5)).name;
end
% Toggle 6 (Cell)
if length(dirFlags) >= 6
    handles.Dir6.String = files(dirFlags(6)).name;
end
% Toggle 7 (Cell)
if length(dirFlags) >= 7
    handles.Dir7.String = files(dirFlags(7)).name;
end
% Toggle 8 (Cell)
if length(dirFlags) >= 8
    handles.Dir8.String = files(dirFlags(8)).name;
end
% Toggle 9 (Cell)
if length(dirFlags) >= 9
    handles.Dir9.String = files(dirFlags(9)).name;
end
% Toggle 10 (Cell)
if length(dirFlags) >= 10
    handles.Dir10.String = files(dirFlags(10)).name;
end
% Toggle 11 (Cell)
if length(dirFlags) >= 11
    handles.Dir11.String = files(dirFlags(11)).name;
end
% Toggle 12 (Cell)
if length(dirFlags) >= 12
    handles.Dir12.String = files(dirFlags(12)).name;
end
% Toggle 13 (Cell)
if length(dirFlags) >= 13
    handles.Dir13.String = files(dirFlags(13)).name;
end
% Toggle 14 (Cell)
if length(dirFlags) >= 14
    handles.Dir14.String = files(dirFlags(14)).name;
end
% Toggle 15 (Cell)
if length(dirFlags) >= 15
    handles.Dir15.String = files(dirFlags(15)).name;
end
% Toggle 16 (Cell)
if length(dirFlags) >= 16
    handles.Dir16.String = files(dirFlags(16)).name;
end
% Toggle 17 (Cell)
if length(dirFlags) >= 17
    handles.Dir17.String = files(dirFlags(17)).name;
end
% Toggle 18 (Cell)
if length(dirFlags) >= 18
    handles.Dir18.String = files(dirFlags(18)).name;
end
% Toggle 19 (Cell)
if length(dirFlags) >= 19
    handles.Dir19.String = files(dirFlags(19)).name;
end
% Toggle 20 (Cell)
if length(dirFlags) >= 20
    handles.Dir20.String = files(dirFlags(20)).name;
end


% Toggle 1 (Background)
if ~isempty(dirFlags)
    handles.Back1.String = files(dirFlags(1)).name;
end
% Toggle 2 (Background)
if length(dirFlags) >= 2
    handles.Back2.String = files(dirFlags(2)).name;
end
% Toggle 3 (Background)
if length(dirFlags) >= 3
    handles.Back3.String = files(dirFlags(3)).name;
end
% Toggle 4 (Background)
if length(dirFlags) >= 4
    handles.Back4.String = files(dirFlags(4)).name;
end
% Toggle 5 (Background)
if length(dirFlags) >= 5
    handles.Back5.String = files(dirFlags(5)).name;
end
% Toggle 6 (Background)
if length(dirFlags) >= 6
    handles.Back6.String = files(dirFlags(6)).name;
end
% Toggle 7 (Background)
if length(dirFlags) >= 7
    handles.Back7.String = files(dirFlags(7)).name;
end
% Toggle 8 (Background)
if length(dirFlags) >= 8
    handles.Back8.String = files(dirFlags(8)).name;
end
% Toggle 9 (Background)
if length(dirFlags) >= 9
    handles.Back9.String = files(dirFlags(9)).name;
end
% Toggle 10 (Background)
if length(dirFlags) >= 10
    handles.Back10.String = files(dirFlags(10)).name;
end
% Toggle 11 (Background)
if length(dirFlags) >= 11
    handles.Back11.String = files(dirFlags(11)).name;
end
% Toggle 12 (Background)
if length(dirFlags) >= 12
    handles.Back12.String = files(dirFlags(12)).name;
end
% Toggle 13 (Background)
if length(dirFlags) >= 13
    handles.Back13.String = files(dirFlags(13)).name;
end
% Toggle 14 (Background)
if length(dirFlags) >= 14
    handles.Back14.String = files(dirFlags(14)).name;
end
% Toggle 15 (Background)
if length(dirFlags) >= 15
    handles.Back15.String = files(dirFlags(15)).name;
end
% Toggle 16 (Background)
if length(dirFlags) >= 16
    handles.Back16.String = files(dirFlags(16)).name;
end
% Toggle 17 (Background)
if length(dirFlags) >= 17
    handles.Back17.String = files(dirFlags(17)).name;
end
% Toggle 18 (Background)
if length(dirFlags) >= 18
    handles.Back18.String = files(dirFlags(18)).name;
end
% Toggle 19 (Background)
if length(dirFlags) >= 19
    handles.Back19.String = files(dirFlags(19)).name;
end
% Toggle 20 (Background)
if length(dirFlags) >= 20
    handles.Back20.String = files(dirFlags(20)).name;
end
% Hints: get(hObject,'String') returns contents of DispDir as text
%        str2double(get(hObject,'String')) returns contents of DispDir as a double


% --- Executes during object creation, after setting all properties.
function DispDir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DispDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Start.
function Start_Callback(hObject, eventdata, handles)
% hObject    handle to Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(handles.Device, '') || isempty(handles.Device)
    handles.Status.String{3} = 'Please, select type of device';
    handles.Status.String{4} = '<----------------------------------------';
    return
end
% Indicate that the image processing starts
if handles.Start.Value ==1
    handles.Status.String{3} = 'Setting Up...';
    handles.Status.String{4} = ' ';
    pause(1)
end 
 
ident = handles.Identifier.String; % Experiment identifier
mainDir = handles.DispDir.String; % Main directory for the experiment

if  isempty(mainDir)
    handles.Status.String{3} = 'Please, select the experiment directory';
    handles.Status.String{4} = ' ';
    return
end

CellDirs = cell(1,20); % Where subdirectories with cells will be saved
BackDirs = cell(1,20); % Where subdirectories with background will be saved

% handles with the toggles
cells = [handles.Dir1, handles.Dir2, handles.Dir3, handles.Dir4, handles.Dir5, handles.Dir6,...
    handles.Dir7, handles.Dir8, handles.Dir9, handles.Dir10, handles.Dir11, handles.Dir12, handles.Dir13,...
    handles.Dir14, handles.Dir15, handles.Dir16, handles.Dir17, handles.Dir18, handles.Dir19, handles.Dir20];
backs = [handles.Back1, handles.Back2, handles.Back3, handles.Back4, handles.Back5, handles.Back6,...
    handles.Back7, handles.Back8, handles.Back9, handles.Back10, handles.Back11, handles.Back12, handles.Back13,...
    handles.Back14, handles.Back15, handles.Back16, handles.Back17, handles.Back18, handles.Back19, handles.Back20];

% Get directories stored
for i = 1:20
    if cells(i).Value==1 && ~isempty(cells(i).String)
        CellDirs{1,i} = [mainDir, '\', cells(i).String];
    end
end
for i = 1:20
    if backs(i).Value==1 && ~isempty(backs(i).String)
        BackDirs{1,i} = [mainDir, '\', backs(i).String];
    end
end
% Delete empty cells
CellDirs = CellDirs(~cellfun('isempty',CellDirs));
BackDirs = BackDirs(~cellfun('isempty',BackDirs));

if  isempty(CellDirs)
    handles.Status.String{3} = 'Please, select one directory with cells';
    handles.Status.String{4} = ' ';
    return
end



% START Processing
% [handles, mainDir, INP, CitFreq, ident, IndInf, datenow] = OnLine_ImageProcessing_Bacteria(ident, mainDir, CellDirs, BackDirs, handles);
[handles, mainDir, INP, CitFreq, ident, IndInf] = OnLine_ImageProcessing_Unif(ident, mainDir, CellDirs, BackDirs, handles);

if isfolder('D:\AcquisitionDataRiddler')
    guidata(hObject,handles);
    start(handles.myTimer)
    % wait(t)
    pause(handles.maxt+900)
    stop(handles.myTimer)
    delete(handles.myTimer);
end

switch handles.Device
    case 'Yeast'
        ExtractDataAsCSVOnLineTemp_YST(mainDir, INP, CitFreq, ident)
    case 'Bacteria'
        ExtractDataAsCSVOnLineTemp_Bact(mainDir, INP, CitFreq, ident, IndInf);
end


% disp('Experiment Finished!')
handles.Status.String{3} = 'Image Processing Finished!  ;)';

% pause(30)
% handles.Status.String{3} = 'Transfering files to external drive...';
% pause(1)
% CheckFileTransfer(mainDir, ident, datenow)
% handles.Status.String{3} = 'FINISHED! Yay!';
% pause(1)

% Quit ImageJ
ij.IJ.run("Quit","");




% handles.Status.String{3} = 'Image Processing Finished!  ;)';


% --- Executes on button press in Stop.
function Stop_Callback(hObject, eventdata, handles)

% delete(timerfind); % CANNOT USE STOPSSSSS!!!!!
if handles.Stop.Value ==1
    stop(handles.myTimer)
    delete(handles.myTimer);
    ij.IJ.run("Quit","");
    handles.Status.String{3} = 'Image Processing Stopped  :(';
    handles.Status.String{4} = 'Please, do Ctrl+C in console';
    
end
% hObject    handle to Stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Dir1.
function Dir1_Callback(hObject, eventdata, handles)
% hObject    handle to Dir1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.Dir1.String)
    if handles.Dir1.Value == 0
        handles.Dir1.BackgroundColor = [0.94 0.94 0.94];
        handles.Dir1.ForegroundColor = [0 0 0];
    elseif handles.Dir1.Value == 1
        handles.Dir1.BackgroundColor = [1 0.3098 0.3098];
        handles.Dir1.ForegroundColor = [1 1 1];
    end
end


% Hint: get(hObject,'Value') returns toggle state of Dir1


% --- Executes on button press in Dir2.
function Dir2_Callback(hObject, eventdata, handles)
% hObject    handle to Dir2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Dir2.String)
    if handles.Dir2.Value == 0
        handles.Dir2.BackgroundColor = [0.94 0.94 0.94];
        handles.Dir2.ForegroundColor = [0 0 0];
    elseif handles.Dir2.Value == 1
        handles.Dir2.BackgroundColor = [1 0.3098 0.3098];
        handles.Dir2.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Dir2


% --- Executes on button press in Dir3.
function Dir3_Callback(hObject, eventdata, handles)
% hObject    handle to Dir3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Dir3.String)
    if handles.Dir3.Value == 0
        handles.Dir3.BackgroundColor = [0.94 0.94 0.94];
        handles.Dir3.ForegroundColor = [0 0 0];
    elseif handles.Dir3.Value == 1
        handles.Dir3.BackgroundColor = [1 0.3098 0.3098];
        handles.Dir3.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Dir3


% --- Executes on button press in Dir4.
function Dir4_Callback(hObject, eventdata, handles)
% hObject    handle to Dir4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Dir4.String)
    if handles.Dir4.Value == 0
        handles.Dir4.BackgroundColor = [0.94 0.94 0.94];
        handles.Dir4.ForegroundColor = [0 0 0];
    elseif handles.Dir4.Value == 1
        handles.Dir4.BackgroundColor = [1 0.3098 0.3098];
        handles.Dir4.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Dir4


% --- Executes on button press in Dir5.
function Dir5_Callback(hObject, eventdata, handles)
% hObject    handle to Dir5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Dir5.String)
    if handles.Dir5.Value == 0
        handles.Dir5.BackgroundColor = [0.94 0.94 0.94];
        handles.Dir5.ForegroundColor = [0 0 0];
    elseif handles.Dir5.Value == 1
        handles.Dir5.BackgroundColor = [1 0.3098 0.3098];
        handles.Dir5.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Dir5


% --- Executes on button press in Dir6.
function Dir6_Callback(hObject, eventdata, handles)
% hObject    handle to Dir6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Dir6.String)
    if handles.Dir6.Value == 0
        handles.Dir6.BackgroundColor = [0.94 0.94 0.94];
        handles.Dir6.ForegroundColor = [0 0 0];
    elseif handles.Dir6.Value == 1
        handles.Dir6.BackgroundColor = [1 0.3098 0.3098];
        handles.Dir6.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Dir6


% --- Executes on button press in Dir7.
function Dir7_Callback(hObject, eventdata, handles)
% hObject    handle to Dir7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Dir7.String)
    if handles.Dir7.Value == 0
        handles.Dir7.BackgroundColor = [0.94 0.94 0.94];
        handles.Dir7.ForegroundColor = [0 0 0];
    elseif handles.Dir7.Value == 1
        handles.Dir7.BackgroundColor = [1 0.3098 0.3098];
        handles.Dir7.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Dir7


% --- Executes on button press in Dir8.
function Dir8_Callback(hObject, eventdata, handles)
% hObject    handle to Dir8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Dir8.String)
    if handles.Dir8.Value == 0
        handles.Dir8.BackgroundColor = [0.94 0.94 0.94];
        handles.Dir8.ForegroundColor = [0 0 0];
    elseif handles.Dir8.Value == 1
        handles.Dir8.BackgroundColor = [1 0.3098 0.3098];
        handles.Dir8.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Dir8


% --- Executes on button press in Dir9.
function Dir9_Callback(hObject, eventdata, handles)
% hObject    handle to Dir9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Dir9.String)
    if handles.Dir9.Value == 0
        handles.Dir9.BackgroundColor = [0.94 0.94 0.94];
        handles.Dir9.ForegroundColor = [0 0 0];
    elseif handles.Dir9.Value == 1
        handles.Dir9.BackgroundColor = [1 0.3098 0.3098];
        handles.Dir9.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Dir9


% --- Executes on button press in Dir10.
function Dir10_Callback(hObject, eventdata, handles)
% hObject    handle to Dir10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Dir10.String)
    if handles.Dir10.Value == 0
        handles.Dir10.BackgroundColor = [0.94 0.94 0.94];
        handles.Dir10.ForegroundColor = [0 0 0];
    elseif handles.Dir10.Value == 1
        handles.Dir10.BackgroundColor = [1 0.3098 0.3098];
        handles.Dir10.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Dir10


% --- Executes on button press in Dir11.
function Dir11_Callback(hObject, eventdata, handles)
% hObject    handle to Dir11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Dir11.String)
    if handles.Dir11.Value == 0
        handles.Dir11.BackgroundColor = [0.94 0.94 0.94];
        handles.Dir11.ForegroundColor = [0 0 0];
    elseif handles.Dir11.Value == 1
        handles.Dir11.BackgroundColor = [1 0.3098 0.3098];
        handles.Dir11.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Dir11


% --- Executes on button press in Dir12.
function Dir12_Callback(hObject, eventdata, handles)
% hObject    handle to Dir12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Dir12.String)
    if handles.Dir12.Value == 0
        handles.Dir12.BackgroundColor = [0.94 0.94 0.94];
        handles.Dir12.ForegroundColor = [0 0 0];
    elseif handles.Dir12.Value == 1
        handles.Dir12.BackgroundColor = [1 0.3098 0.3098];
        handles.Dir12.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Dir12


% --- Executes on button press in Dir13.
function Dir13_Callback(hObject, eventdata, handles)
% hObject    handle to Dir13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Dir13.String)
    if handles.Dir13.Value == 0
        handles.Dir13.BackgroundColor = [0.94 0.94 0.94];
        handles.Dir13.ForegroundColor = [0 0 0];
    elseif handles.Dir13.Value == 1
        handles.Dir13.BackgroundColor = [1 0.3098 0.3098];
        handles.Dir13.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Dir13


% --- Executes on button press in Dir14.
function Dir14_Callback(hObject, eventdata, handles)
% hObject    handle to Dir14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Dir14.String)
    if handles.Dir14.Value == 0
        handles.Dir14.BackgroundColor = [0.94 0.94 0.94];
        handles.Dir14.ForegroundColor = [0 0 0];
    elseif handles.Dir14.Value == 1
        handles.Dir14.BackgroundColor = [1 0.3098 0.3098];
        handles.Dir14.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Dir14


% --- Executes on button press in Dir15.
function Dir15_Callback(hObject, eventdata, handles)
% hObject    handle to Dir15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Dir15.String)
    if handles.Dir15.Value == 0
        handles.Dir15.BackgroundColor = [0.94 0.94 0.94];
        handles.Dir15.ForegroundColor = [0 0 0];
    elseif handles.Dir15.Value == 1
        handles.Dir15.BackgroundColor = [1 0.3098 0.3098];
        handles.Dir15.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Dir15


% --- Executes on button press in Dir16.
function Dir16_Callback(hObject, eventdata, handles)
% hObject    handle to Dir16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Dir16.String)
    if handles.Dir16.Value == 0
        handles.Dir16.BackgroundColor = [0.94 0.94 0.94];
        handles.Dir16.ForegroundColor = [0 0 0];
    elseif handles.Dir16.Value == 1
        handles.Dir16.BackgroundColor = [1 0.3098 0.3098];
        handles.Dir16.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Dir16


% --- Executes on button press in Dir17.
function Dir17_Callback(hObject, eventdata, handles)
% hObject    handle to Dir17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Dir17.String)
    if handles.Dir17.Value == 0
        handles.Dir17.BackgroundColor = [0.94 0.94 0.94];
        handles.Dir17.ForegroundColor = [0 0 0];
    elseif handles.Dir17.Value == 1
        handles.Dir17.BackgroundColor = [1 0.3098 0.3098];
        handles.Dir17.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Dir17


% --- Executes on button press in Dir18.
function Dir18_Callback(hObject, eventdata, handles)
% hObject    handle to Dir18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Dir18.String)
    if handles.Dir18.Value == 0
        handles.Dir18.BackgroundColor = [0.94 0.94 0.94];
        handles.Dir18.ForegroundColor = [0 0 0];
    elseif handles.Dir18.Value == 1
        handles.Dir18.BackgroundColor = [1 0.3098 0.3098];
        handles.Dir18.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Dir18


% --- Executes on button press in Dir19.
function Dir19_Callback(hObject, eventdata, handles)
% hObject    handle to Dir19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Dir19.String)
    if handles.Dir19.Value == 0
        handles.Dir19.BackgroundColor = [0.94 0.94 0.94];
        handles.Dir19.ForegroundColor = [0 0 0];
    elseif handles.Dir19.Value == 1
        handles.Dir19.BackgroundColor = [1 0.3098 0.3098];
        handles.Dir19.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Dir19


% --- Executes on button press in Dir20.
function Dir20_Callback(hObject, eventdata, handles)
% hObject    handle to Dir20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Dir20.String)
    if handles.Dir20.Value == 0
        handles.Dir20.BackgroundColor = [0.94 0.94 0.94];
        handles.Dir20.ForegroundColor = [0 0 0];
    elseif handles.Dir20.Value == 1
        handles.Dir20.BackgroundColor = [1 0.3098 0.3098];
        handles.Dir20.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Dir20


% --- Executes on button press in Back1.
function Back1_Callback(hObject, eventdata, handles)
% hObject    handle to Back1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Back1.String)
    if handles.Back1.Value == 0
        handles.Back1.BackgroundColor = [0.94 0.94 0.94];
        handles.Back1.ForegroundColor = [0 0 0];
    elseif handles.Back1.Value == 1
        handles.Back1.BackgroundColor = [0.3922 0.8314 0.0745];
        handles.Back1.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Back1


% --- Executes on button press in Back2.
function Back2_Callback(hObject, eventdata, handles)
% hObject    handle to Back2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Back2.String)
    if handles.Back2.Value == 0
        handles.Back2.BackgroundColor = [0.94 0.94 0.94];
        handles.Back2.ForegroundColor = [0 0 0];
    elseif handles.Back2.Value == 1
        handles.Back2.BackgroundColor = [0.3922 0.8314 0.0745];
        handles.Back2.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Back2


% --- Executes on button press in Back3.
function Back3_Callback(hObject, eventdata, handles)
% hObject    handle to Back3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Back3.String)
    if handles.Back3.Value == 0
        handles.Back3.BackgroundColor = [0.94 0.94 0.94];
        handles.Back3.ForegroundColor = [0 0 0];
    elseif handles.Back3.Value == 1
        handles.Back3.BackgroundColor = [0.3922 0.8314 0.0745];
        handles.Back3.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Back3


% --- Executes on button press in Back4.
function Back4_Callback(hObject, eventdata, handles)
% hObject    handle to Back4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Back4.String)
    if handles.Back4.Value == 0
        handles.Back4.BackgroundColor = [0.94 0.94 0.94];
        handles.Back4.ForegroundColor = [0 0 0];
    elseif handles.Back4.Value == 1
        handles.Back4.BackgroundColor = [0.3922 0.8314 0.0745];
        handles.Back4.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Back4


% --- Executes on button press in Back5.
function Back5_Callback(hObject, eventdata, handles)
% hObject    handle to Back5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Back5.String)
    if handles.Back5.Value == 0
        handles.Back5.BackgroundColor = [0.94 0.94 0.94];
        handles.Back5.ForegroundColor = [0 0 0];
    elseif handles.Back5.Value == 1
        handles.Back5.BackgroundColor = [0.3922 0.8314 0.0745];
        handles.Back5.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Back5


% --- Executes on button press in Back6.
function Back6_Callback(hObject, eventdata, handles)
% hObject    handle to Back6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Back6.String)
    if handles.Back6.Value == 0
        handles.Back6.BackgroundColor = [0.94 0.94 0.94];
        handles.Back6.ForegroundColor = [0 0 0];
    elseif handles.Back6.Value == 1
        handles.Back6.BackgroundColor = [0.3922 0.8314 0.0745];
        handles.Back6.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Back6


% --- Executes on button press in Back7.
function Back7_Callback(hObject, eventdata, handles)
% hObject    handle to Back7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Back7.String)
    if handles.Back7.Value == 0
        handles.Back7.BackgroundColor = [0.94 0.94 0.94];
        handles.Back7.ForegroundColor = [0 0 0];
    elseif handles.Back7.Value == 1
        handles.Back7.BackgroundColor = [0.3922 0.8314 0.0745];
        handles.Back7.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Back7


% --- Executes on button press in Back8.
function Back8_Callback(hObject, eventdata, handles)
% hObject    handle to Back8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Back8.String)
    if handles.Back8.Value == 0
        handles.Back8.BackgroundColor = [0.94 0.94 0.94];
        handles.Back8.ForegroundColor = [0 0 0];
    elseif handles.Back8.Value == 1
        handles.Back8.BackgroundColor = [0.3922 0.8314 0.0745];
        handles.Back8.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Back8


% --- Executes on button press in Back9.
function Back9_Callback(hObject, eventdata, handles)
% hObject    handle to Back9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Back9.String)
    if handles.Back9.Value == 0
        handles.Back9.BackgroundColor = [0.94 0.94 0.94];
        handles.Back9.ForegroundColor = [0 0 0];
    elseif handles.Back9.Value == 1
        handles.Back9.BackgroundColor = [0.3922 0.8314 0.0745];
        handles.Back9.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Back9


% --- Executes on button press in Back10.
function Back10_Callback(hObject, eventdata, handles)
% hObject    handle to Back10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Back10.String)
    if handles.Back10.Value == 0
        handles.Back10.BackgroundColor = [0.94 0.94 0.94];
        handles.Back10.ForegroundColor = [0 0 0];
    elseif handles.Back10.Value == 1
        handles.Back10.BackgroundColor = [0.3922 0.8314 0.0745];
        handles.Back10.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Back10


% --- Executes on button press in Back11.
function Back11_Callback(hObject, eventdata, handles)
% hObject    handle to Back11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Back11.String)
    if handles.Back11.Value == 0
        handles.Back11.BackgroundColor = [0.94 0.94 0.94];
        handles.Back11.ForegroundColor = [0 0 0];
    elseif handles.Back11.Value == 1
        handles.Back11.BackgroundColor = [0.3922 0.8314 0.0745];
        handles.Back11.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Back11


% --- Executes on button press in Back12.
function Back12_Callback(hObject, eventdata, handles)
% hObject    handle to Back12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Back12.String)
    if handles.Back12.Value == 0
        handles.Back12.BackgroundColor = [0.94 0.94 0.94];
        handles.Back12.ForegroundColor = [0 0 0];
    elseif handles.Back12.Value == 1
        handles.Back12.BackgroundColor = [0.3922 0.8314 0.0745];
        handles.Back12.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Back12


% --- Executes on button press in Back13.
function Back13_Callback(hObject, eventdata, handles)
% hObject    handle to Back13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Back13.String)
    if handles.Back13.Value == 0
        handles.Back13.BackgroundColor = [0.94 0.94 0.94];
        handles.Back13.ForegroundColor = [0 0 0];
    elseif handles.Back13.Value == 1
        handles.Back13.BackgroundColor = [0.3922 0.8314 0.0745];
        handles.Back13.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Back13


% --- Executes on button press in Back14.
function Back14_Callback(hObject, eventdata, handles)
% hObject    handle to Back14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Back14.String)
    if handles.Back14.Value == 0
        handles.Back14.BackgroundColor = [0.94 0.94 0.94];
        handles.Back14.ForegroundColor = [0 0 0];
    elseif handles.Back14.Value == 1
        handles.Back14.BackgroundColor = [0.3922 0.8314 0.0745];
        handles.Back14.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Back14


% --- Executes on button press in Back15.
function Back15_Callback(hObject, eventdata, handles)
% hObject    handle to Back15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Back15.String)
    if handles.Back15.Value == 0
        handles.Back15.BackgroundColor = [0.94 0.94 0.94];
        handles.Back15.ForegroundColor = [0 0 0];
    elseif handles.Back15.Value == 1
        handles.Back15.BackgroundColor = [0.3922 0.8314 0.0745];
        handles.Back15.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Back15


% --- Executes on button press in Back16.
function Back16_Callback(hObject, eventdata, handles)
% hObject    handle to Back16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Back16.String)
    if handles.Back16.Value == 0
        handles.Back16.BackgroundColor = [0.94 0.94 0.94];
        handles.Back16.ForegroundColor = [0 0 0];
    elseif handles.Back16.Value == 1
        handles.Back16.BackgroundColor = [0.3922 0.8314 0.0745];
        handles.Back16.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Back16


% --- Executes on button press in Back17.
function Back17_Callback(hObject, eventdata, handles)
% hObject    handle to Back17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Back17.String)
    if handles.Back17.Value == 0
        handles.Back17.BackgroundColor = [0.94 0.94 0.94];
        handles.Back17.ForegroundColor = [0 0 0];
    elseif handles.Back17.Value == 1
        handles.Back17.BackgroundColor = [0.3922 0.8314 0.0745];
        handles.Back17.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Back17


% --- Executes on button press in Back18.
function Back18_Callback(hObject, eventdata, handles)
% hObject    handle to Back18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Back18.String)
    if handles.Back18.Value == 0
        handles.Back18.BackgroundColor = [0.94 0.94 0.94];
        handles.Back18.ForegroundColor = [0 0 0];
    elseif handles.Back18.Value == 1
        handles.Back18.BackgroundColor = [0.3922 0.8314 0.0745];
        handles.Back18.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Back18


% --- Executes on button press in Back19.
function Back19_Callback(hObject, eventdata, handles)
% hObject    handle to Back19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Back19.String)
    if handles.Back19.Value == 0
        handles.Back19.BackgroundColor = [0.94 0.94 0.94];
        handles.Back19.ForegroundColor = [0 0 0];
    elseif handles.Back19.Value == 1
        handles.Back19.BackgroundColor = [0.3922 0.8314 0.0745];
        handles.Back19.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Back19


% --- Executes on button press in Back20.
function Back20_Callback(hObject, eventdata, handles)
% hObject    handle to Back20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.Back20.String)
    if handles.Back20.Value == 0
        handles.Back20.BackgroundColor = [0.94 0.94 0.94];
        handles.Back20.ForegroundColor = [0 0 0];
    elseif handles.Back20.Value == 1
        handles.Back20.BackgroundColor = [0.3922 0.8314 0.0745];
        handles.Back20.ForegroundColor = [1 1 1];
    end
end
% Hint: get(hObject,'Value') returns toggle state of Back20


% --- Executes during object creation, after setting all properties.
function Image1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Image1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if handles.YeastDevice.Value==1
    s = imread(['Miscelaneous\Yeast.jpg']);
    imshow(mat2gray(s));
elseif handles.BacteriaDevice.Value==1
    s = imread(['Miscelaneous\bacteria.jpg']);
    imshow(mat2gray(s));
end

% Hint: place code in OpeningFcn to populate Image1


% --- Executes on button press in YeastDevice.
function YeastDevice_Callback(hObject, eventdata, handles)
% hObject    handle to YeastDevice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles
if handles.YeastDevice.Value==1
    handles.BacteriaDevice.Value = 0;
end
handles.Ttitle.String = 'Yeast On-Line Image Processing';
handles.Identifier.String = 'S.cerevisiae';
Image1_CreateFcn(hObject, eventdata, handles)
handles.Status.String{3} = 'IPP for Yeast Started';
handles.Status.String{4} = ' ';
handles.Device = 'Yeast';
guidata(hObject, handles);


% --- Executes on button press in BacteriaDevice.
function BacteriaDevice_Callback(hObject, eventdata, handles)
% hObject    handle to BacteriaDevice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.BacteriaDevice.Value==1
    handles.YeastDevice.Value = 0;
end
handles.Ttitle.String = 'Bacteria On-Line Image Processing';
handles.Identifier.String = 'E.coli';
Image1_CreateFcn(hObject, eventdata, handles)
handles.Status.String{3} = 'IPP for Bacteria Started';
handles.Status.String{4} = ' ';
handles.Device = 'Bacteria';
guidata(hObject, handles);


% --- Executes on button press in SegmentCY5.
function SegmentCY5_Callback(hObject, eventdata, handles)
% hObject    handle to SegmentCY5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.SegmentCY5.Value==1
%     disp('Fluoresence Images from Background possition are going to be segmented for better accuracy')
    handles.Status.String{3} = 'Background Fluoresence Images will be segmented';
    handles.Status.String{4} = ' ';
elseif handles.SegmentCY5.Value==0
%     disp('Fluoresence Images from Background possition are NOT going to be segmented')
    handles.Status.String{3} = 'Background Fluoresence Images will NOT be segmented';
    handles.Status.String{4} = ' ';
end
% disp(handles.SegmentCY5.Value)
% Hint: get(hObject,'Value') returns toggle state of SegmentCY5
