function varargout = janus3D_license(varargin)
% JANUS3D_LICENSE MATLAB code for janus3D_license.fig
%      JANUS3D_LICENSE, by itself, creates a new JANUS3D_LICENSE or raises the existing
%      singleton*.
%
%      H = JANUS3D_LICENSE returns the handle to a new JANUS3D_LICENSE or the handle to
%      the existing singleton*.
%
%      JANUS3D_LICENSE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in JANUS3D_LICENSE.M with the given input arguments.
%
%      JANUS3D_LICENSE('Property','Value',...) creates a new JANUS3D_LICENSE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before janus3D_license_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to janus3D_license_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help janus3D_license

% Last Modified by GUIDE v2.5 27-Oct-2015 16:47:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @janus3D_license_OpeningFcn, ...
                   'gui_OutputFcn',  @janus3D_license_OutputFcn, ...
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


% --- Executes just before janus3D_license is made visible.
function janus3D_license_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to janus3D_license (see VARARGIN)

% Choose default command line output for janus3D_license
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes janus3D_license wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = janus3D_license_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
