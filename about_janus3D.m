function varargout = about_janus3D(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @about_janus3D_OpeningFcn, ...
    'gui_OutputFcn',  @about_janus3D_OutputFcn, ...
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


% --- Executes just before about_janus3D is made visible.
function about_janus3D_OpeningFcn(hObject, eventdata, handles, varargin)
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
set(logohandle,'ButtonDownFcn','options_and_about');

% --- Outputs from this function are returned to the command line.
function varargout = about_janus3D_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;
