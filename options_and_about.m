function varargout = options_and_about(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @options_and_about_OpeningFcn, ...
                   'gui_OutputFcn',  @options_and_about_OutputFcn, ...
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


% --- Executes just before options_and_about is made visible.
function options_and_about_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.axes1, 'Units', 'pixels');
logo=imread(['Logo.png']);
info=imfinfo(['Logo.png']);
position = get(handles.axes1, 'Position');
axes(handles.axes1);
logohandle=image(logo);
set(handles.axes1, ...
    'Visible', 'off', ...
    'Units', 'pixels');
foldercontent=dir([fileparts(which(mfilename)) filesep 'private' filesep]);
foldercontent={foldercontent(:,1).name}';
has_temp=find(strcmp(foldercontent,'current_cap_template.mat')==1);
if size(has_temp,1)==0
   set(handles.text4,'String','not set')
else
    load([fileparts(which(mfilename)) filesep 'private' filesep 'current_cap_template.mat'])
    set(handles.text4,'String',template.type)
end

% --- Outputs from this function are returned to the command line.
function varargout = options_and_about_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
[FileName,PathName,FilterIndex]=uigetfile(fullfile(fileparts(which(mfilename)),[filesep 'private' filesep 'templates'],'*.mat'));
if PathName~=0
load([PathName,FileName]);    
path=fileparts(which(mfilename));
save([path,filesep 'private' filesep 'current_cap_template.mat'],'template')
set(handles.text4,'String',template.type)
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
close gcf
