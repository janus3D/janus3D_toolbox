function varargout = janus3D(varargin)
% janus3D MATLAB code for janus3D.fig
%      janus3D, by itself, creates a new janus3D or raises the existing
%      singleton*.
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @janus3D_OpeningFcn, ...
    'gui_OutputFcn',  @janus3D_OutputFcn, ...
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

% --- Executes just before janus_GUI_test is made visible.
function janus3D_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to janus3D (see VARARGIN)

% Choose default command line output for janus3D
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes janus3D wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = janus3D_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
clearvars -global int_model MRI FileName PathName session_name Log

janus3D_pathset( 'add' )

varargout{1} = handles.output;
janus3D_defaults(handles,'no')

function done(source,callback)
delete(gcf)
options_and_about


% --- Executes on button press in pushbutton1.
function save_session_Callback(hObject, eventdata, handles)
global int_model
global MRI
global FileName
global PathName
global session_name
global Log
if isempty(FileName) || isempty(PathName) || isnumeric(PathName)
    [FileName,PathName,FilterIndex]=uiputfile('.mat');
end
if PathName~=0
    clc
    set(gcf, 'pointer', 'watch')
    drawnow;
    set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String','saving...')
    drawnow;
    disp('saving...')
    session=[];
    session.model=int_model;
    session.MRI=MRI;
    Log{end+1,1}=[datestr(datetime('now')),' session saved'];
    session.Log=Log;
    save([PathName,FileName],'session')
    set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String','done.')
    drawnow;
    disp('done.')
    [~,session_name]=fileparts(FileName);
    if exist('handles')
        set(handles.text6, 'String', session_name)
    end
    set(gcf, 'pointer', 'arrow')
end

% --- Executes on button press in pushbutton2.
function load_session_Callback(hObject, eventdata, handles)
global PathName
global FileName
[FileName,PathName,FilterIndex]=uigetfile('.mat');
if PathName~=0
    janus3D_defaults(handles,'no')
    clearvars -global int_model MRI session_name Log
    global int_model
    global MRI
    global session_name
    global Log
    set(handles.figure1, 'pointer', 'watch')
    drawnow;
    clc
    set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String','loading...')
    drawnow;
    disp('loading...')
    load([PathName,FileName]);
    int_model=session.model;
    if ~isfield(int_model,'transmat')
        int_model.transmat=eye(4);
    end
    MRI=session.MRI;
    if isfield(session,'Log')
        Log=session.Log;
    else
        Log=[];
    end
    Log{end+1,1}=[datestr(datetime('now')),' session loaded'];
    janus3D_button_handler( int_model,MRI,handles )
    set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String','done.')
    drawnow;
    disp('done.')
    clearvars -global session
    [~,session_name]=fileparts(FileName);
    set(handles.text6, 'String', session_name)
    if isfield(handles,'text9')
        delete(handles.text9)
    end
    
    if isfield(handles,'text10')
        delete(handles.text10)
    end
    
end
janus3D_defaults(handles,'yes')

% --- Executes on button press in pushbutton3.
function done_session_Callback(hObject, eventdata, handles)
global int_model
delete(gcf)
if exist('int_model')
    if ~isempty(int_model)
        assignin('base', 'model', int_model)
    end
end
clearvars -global int_model MRI FileName PathName session_name Log


% --- Executes on button press in pushbutton7.
function load_model_Callback(hObject, eventdata, handles)
janus3D_defaults(handles,'no')
global int_model
global MRI
global Log
[FileName,PathName,FilterIndex]=uigetfile('.obj');
if PathName~=0
    set(handles.figure1, 'pointer', 'watch')
    drawnow;
    clc
    set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String','loading...')
    drawnow;
    disp('loading...')
    int_model=tc_readObj([PathName,FileName]);
    Log{end+1,1}=[datestr(datetime('now')),' int_model read'];
    set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String','done.')
    drawnow;
    disp('done.')
    if isfield(handles,'text9')
        delete(handles.text9)
    end
    
    if isfield(handles,'text10')
        delete(handles.text10)
    end
end
janus3D_defaults(handles,'yes')
janus3D_button_handler( int_model,MRI,handles )

% --- Executes on button press in pushbutton8.
function position_model_Callback(hObject, eventdata, handles)
janus3D_defaults(handles,'no')
global int_model
global MRI
global Log

if ~isfield(int_model,'transmat')
    int_model.transmat=eye(4);
end

[int_model,transmat]=tc_prepareModel(int_model,handles);
int_model.transmat=transmat*int_model.transmat;
Log{end+1,1}=[datestr(datetime('now')),' int_model positioned'];
janus3D_defaults(handles,'yes')
janus3D_button_handler( int_model,MRI,handles )


% --- Executes on button press in pushbutton9.
function de_face_model_Callback(hObject, eventdata, handles)
janus3D_defaults(handles,'no')
global int_model
global MRI
global Log
if  isfield(MRI,'Face')
    Face=MRI.VCoord(MRI.Face.VInd,:);
    Face_surf=boundary(-Face(:,2),Face(:,3));
    Face_surf=[Face(Face_surf,2),Face(Face_surf,3)];
else
    Face_surf=[];
end
color=[119/255,202/255,242/255];
int_model=tc_defacer(int_model,Face_surf,color,handles);
Log{end+1,1}=[datestr(datetime('now')),' int_model de-faced'];
janus3D_defaults(handles,'yes')
janus3D_button_handler( int_model,MRI,handles )

% --- Executes on button press in pushbutton10.
function load_MRI_Callback(hObject, eventdata, handles)
janus3D_defaults(handles,'no')
global MRI
global int_model
global Log
[FileName,PathName,FilterIndex]=uigetfile('.nii');
if PathName~=0
    set(handles.figure1, 'pointer', 'watch')
    drawnow;
    clc
    set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String','loading...')
    drawnow;
    disp('loading...')
    MRI=ft_read_mri([PathName,FileName]);
    MRI.coordsys='xyz';
    cfg           = [];
    cfg.output    = {'scalp'};
    cfg.scalpsmooth = 5;
    %cfg.scalpthreshold = 0.085;
    segment_tpm   = ft_volumesegment(cfg,MRI);
    
    cfg             = [];
    cfg.method      = 'projectmesh';
    cfg.tissue      = {'scalp'};
    cfg.numvertices = [24000];
    bnd             = ft_prepare_mesh(cfg, segment_tpm);
    
    Mesh_MRI=bnd;
    Mesh_MRI.VCoord=bnd.pnt;
    Mesh_MRI.FCoord(:,[1,3,5])=bnd.tri;
    
    MRI=Mesh_MRI;
    clearvars Mesh_MRI
    set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String','done.')
    drawnow;
    disp('done.')
    Log{end+1,1}=[datestr(datetime('now')),' MRI read'];
    if isfield(handles,'text9')
        delete(handles.text9)
    end
    
    if isfield(handles,'text10')
        delete(handles.text10)
    end
end
janus3D_defaults(handles,'yes')
janus3D_button_handler( int_model,MRI,handles )

% --- Executes on button press in pushbutton11.
function de_face_MRI_Callback(hObject, eventdata, handles)
janus3D_defaults(handles,'no')
global int_model
global MRI
global Log

if  isfield(int_model,'Face')
    Face=int_model.VCoord(int_model.Face.VInd,:);
    Face_surf=boundary(-Face(:,2),Face(:,3));
    Face_surf=[Face(Face_surf,2),Face(Face_surf,3)];
else
    Face_surf=[];
end
color=[241/255,223/255,185/255];
MRI=tc_defacer(MRI,Face_surf,color,handles);
Log{end+1,1}=[datestr(datetime('now')),' MRI de-faced'];
janus3D_defaults(handles,'yes')
janus3D_button_handler( int_model,MRI,handles )



% --- Executes on button press in pushbutton12.
function align_models_Callback(hObject, eventdata, handles)
janus3D_defaults(handles,'no')
global int_model
global MRI
global Log
[int_model,transmat]=tc_alignModels(MRI,int_model,handles);
int_model.transmat=transmat*int_model.transmat;
Log{end+1,1}=[datestr(datetime('now')),' int_model aligned'];
janus3D_defaults(handles,'yes')
janus3D_button_handler( int_model,MRI,handles )

% --- Executes on button press in pushbutton13.
function correct_alignment_Callback(hObject, eventdata, handles)
janus3D_defaults(handles,'no')
global int_model
global MRI
global Log

[int_model,transmat ] = tc_rearrange3D( MRI,int_model,handles);
int_model.transmat=transmat*int_model.transmat;
Log{end+1,1}=[datestr(datetime('now')),' int_model corrected'];
janus3D_defaults(handles,'yes')
janus3D_button_handler( int_model,MRI,handles )


% --- Executes on button press in pushbutton14.
function manual_Callback(hObject, eventdata, handles)
janus3D_defaults(handles,'no')
global int_model
global MRI
global Log
if ~isfield(int_model,'texture')
    int_model.texture=[];
end
[Electrodes,int_model.texture]=tc_sel3D(int_model,int_model.texture,MRI,handles);
Log{end+1,1}=[datestr(datetime('now')),' manual electrode selection'];
Electrodes_on_MRI=Electrodes;
if isfield(Electrodes_on_MRI,'free_selection')
    Electrodes_on_MRI=rmfield(Electrodes_on_MRI,'free_selection');
end
int_model.Electrodes=Electrodes;
if isfield(Electrodes,'points')
    if ~isempty(Electrodes.points)
        Electrodes_on_MRI.points=tc_el2head(Electrodes.points,MRI);
        Log{end+1,1}=[datestr(datetime('now')),' electrodes projected to MRI'];
    end
end
int_model.Electrodes_on_MRI=Electrodes_on_MRI;
janus3D_defaults(handles,'yes')
janus3D_button_handler( int_model,MRI,handles )



% --- Executes on button press in pushbutton15.
function texture_based_Callback(hObject, eventdata, handles)
janus3D_defaults(handles,'no')
global int_model
global MRI
global Log
if ~isfield(int_model,'texture')
    [FileName,PathName,FilterIndex]=uigetfile('.jpg','Select Texture File');
    if PathName~=0
        int_model.texture=imread([PathName,FileName]);
        Log{end+1,1}=[datestr(datetime('now')),' texture file read'];
        [ Electrodepositions ] = tc_findelectrodesontexturedmesh( int_model,int_model.texture,handles);
        Log{end+1,1}=[datestr(datetime('now')),' automatic electrode selection'];
        int_model.Electrodes.points=Electrodepositions;
        int_model.Electrodes_on_MRI.points=tc_el2head(Electrodepositions,MRI);
        Log{end+1,1}=[datestr(datetime('now')),' electrodes projected to MRI'];
        janus3D_defaults(handles,'yes')
        janus3D_button_handler( int_model,MRI,handles )
    end
else
    [ Electrodepositions ] = tc_findelectrodesontexturedmesh( int_model,int_model.texture,handles);
    Log{end+1,1}=[datestr(datetime('now')),' automatic electrode selection'];
    int_model.Electrodes.points=Electrodepositions;
    int_model.Electrodes_on_MRI.points=tc_el2head(Electrodepositions,MRI);
    Log{end+1,1}=[datestr(datetime('now')),' electrodes projected to MRI'];
    janus3D_defaults(handles,'yes')
    janus3D_button_handler( int_model,MRI,handles )
end




% --- Executes on button press in pushbutton16.
function auto_label_Callback(hObject, eventdata, handles)
janus3D_defaults(handles,'no')
global int_model
global MRI
global Log
if ~isempty(int_model.Electrodes.points)
    load('current_cap_template.mat')
    template=template.templates;
    Electrodes=tc_autolabel( int_model.Electrodes,template,handles,MRI);
    Log{end+1,1}=[datestr(datetime('now')),' automatic electrode labeling'];
    int_model.Electrodes.label=Electrodes.label;
    int_model.Electrodes_on_MRI.label=Electrodes.label;
end
janus3D_defaults(handles,'yes')
janus3D_button_handler( int_model,MRI,handles )

% --- Executes on button press in pushbutton21.
function Photo_Masker_Callback(hObject, eventdata, handles)
janus3D_defaults(handles,'no')
tc_createImgMasks(handles)
janus3D_defaults(handles,'yes')

% --- Executes on button press in pushbutton25.
function save_as_session_Callback(hObject, eventdata, handles)
global int_model
global MRI
global FileName
global PathName
global session_name
global Log
clc
[FileName,PathName,FilterIndex]=uiputfile('.mat');
if PathName~=0
    set(handles.figure1, 'pointer', 'watch')
    set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String','saving...')
    drawnow;
    disp('saving...')
    session=[];
    session.model=int_model;
    session.MRI=MRI;
    session.Log=Log;
    save([PathName,FileName],'session')
    set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String','done.')
    drawnow;
    disp('done.')
    [~,session_name]=fileparts(FileName);
    set(handles.text6, 'String', session_name)
    set(handles.figure1, 'pointer', 'arrow')
end

% --- Executes on button press in pushbutton26.
function show_electrodes_Callback(hObject, eventdata, handles)
janus3D_defaults(handles,'no')
global int_model
global MRI
tc_plotmodelswithelec(int_model,MRI,handles);



% --- Executes on button press in pushbutton28.
function new_session_Callback(hObject, eventdata, handles)
global int_model
global MRI
global Log
handles_old=handles;
if ~isempty(int_model) || ~isempty(MRI) || ~isempty(Log)
    new_h=figure('Units','normalized','Position',[0.5 0.5 0.2 0.1],'toolbar','none','Menubar','none','Name','','Numbertitle','off','Color',[0.502 0.502 0.502]);
    uicontrol('Style','text','Units','normalized','Position',[0 0.33 1 0.5],'String','save current session?','ForegroundColor','w','FontSize',16,'BackgroundColor',[0.502 0.502 0.502]);
    uicontrol('Style','pushbutton','Units','normalized','Position',[0.01 0 0.3 0.3],'String','Yes','FontSize',16,'callback',@(hObject,eventdata)janus3D('save_yes',hObject,eventdata,handles_old));
    uicontrol('Style','pushbutton','Units','normalized','Position',[0.34 0 0.3 0.3],'String','No','FontSize',16,'callback',@(hObject,eventdata)janus3D('save_no',hObject,eventdata,handles_old));
    uicontrol('Style','pushbutton','Units','normalized','Position',[0.68 0 0.3 0.3],'String','Cancel','FontSize',16,'callback','delete(gcf)');
else
    done_session_Callback(1,1,handles)
    janus3D
end

function save_yes(hObject, eventdata, handles)
save_session_Callback(1,1,handles)
done_session_Callback(1,1,handles)
delete(gcf);
janus3D

function save_no(hObject, eventdata, handles)
delete(gcf);
done_session_Callback(1,1,handles)
janus3D


% --------------------------------------------------------------------
function file_tag_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function pref_Callback(hObject, eventdata, handles)
global int_model
global MRI
waitfor(options_and_about)
janus3D_button_handler( int_model,MRI,handles )

% --------------------------------------------------------------------
function preproc_tag_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function model_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function MRI_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Aligment_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Electrode_selection_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function help_fcn_Callback(hObject, eventdata, handles)
open('janus3D_users_manual.pdf')

% --------------------------------------------------------------------
function about_Callback(hObject, eventdata, handles)
about_janus3D

% --------------------------------------------------------------------
function license_Callback(hObject, eventdata, handles)
janus3D_license


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
global int_model
close gcf
if ~isempty(int_model)
    assignin('base', 'model', int_model)
end
clearvars -global int_model MRI FileName PathName session_name Log
janus3D_pathset( 'rm' )

% --------------------------------------------------------------------
function temp_build_Callback(hObject, eventdata, handles)
janus3D_template_builder
