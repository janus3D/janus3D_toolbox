function varargout = janus3D_template_builder(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @janus3D_template_builder_OpeningFcn, ...
    'gui_OutputFcn',  @janus3D_template_builder_OutputFcn, ...
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


% --- Executes just before janus3D_template_builder is made visible.
function janus3D_template_builder_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.logo_axes, 'Units', 'pixels');
logo=imread(['Logo.png']);
info=imfinfo(['Logo.png']);
position = get(handles.logo_axes, 'Position');
axes(handles.logo_axes);
handles.logohandle=image(logo);
set(handles.logo_axes, ...
    'Visible', 'off', ...
    'Units', 'pixels');
set(handles.logohandle,'ButtonDownFcn',@(hObject,eventdata)janus3D_template_builder('reset',hObject,eventdata,guidata(hObject)));
axes(handles.main_axes)
set(handles.main_axes,'Color','none','XColor','w','YColor','w','ZColor','w')
h = rotate3d(handles.figure1);
setAllowAxesRotate(h,handles.main_axes,0)
setAllowAxesRotate(h,handles.logo_axes,0)
h = pan(handles.figure1);
setAllowAxesPan(h,handles.logo_axes,0)
h = zoom(handles.figure1);
setAllowAxesZoom(h,handles.logo_axes,0)
clearvars -global template_builder_object
global template_builder_object
template_builder_object=[];

% UIWAIT makes janus3D_template_builder wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = janus3D_template_builder_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global template_builder_object

template_builder_object.current_side=template_builder_object.side_right;

template_builder_object.dim=template_builder_object.dims(2,:);
template_builder_object.set_col=1;
scatter(handles.main_axes,template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(1)),template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(2)),150,'square','filled','CData',template_builder_object.colorcode{1,1}(template_builder_object.current_side,:))
text(template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(1)),template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(2)),template_builder_object.files{1}.label(template_builder_object.current_side,:),'Parent',handles.main_axes)
set(handles.main_axes,'Color','none','XColor','w','YColor','w','ZColor','w')
h = rotate3d(handles.figure1);
setAllowAxesRotate(h,handles.main_axes,0)
set(handles.main_axes,'ButtonDownFcn',@(hObject,eventdata)janus3D_template_builder('down_f',hObject,eventdata,guidata(hObject)));



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
global template_builder_object

template_builder_object.current_side=template_builder_object.side_left;

template_builder_object.dim=template_builder_object.dims(2,:);
template_builder_object.set_col=1;
scatter(handles.main_axes,template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(1)),template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(2)),150,'square','filled','CData',template_builder_object.colorcode{1,1}(template_builder_object.current_side,:))
text(template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(1)),template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(2)),template_builder_object.files{1}.label(template_builder_object.current_side,:),'Parent',handles.main_axes)
set(handles.main_axes,'Color','none','XColor','w','YColor','w','ZColor','w')
h = rotate3d(handles.figure1);
setAllowAxesRotate(h,handles.main_axes,0)
set(handles.main_axes,'ButtonDownFcn',@(hObject,eventdata)janus3D_template_builder('down_f',hObject,eventdata,guidata(hObject)));


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
global template_builder_object

template_builder_object.current_side=template_builder_object.side_front;

template_builder_object.dim=template_builder_object.dims(3,:);
template_builder_object.set_col=1;
scatter(handles.main_axes,template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(1)),template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(2)),150,'square','filled','CData',template_builder_object.colorcode{1,1}(template_builder_object.current_side,:))
text(template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(1)),template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(2)),template_builder_object.files{1}.label(template_builder_object.current_side,:),'Parent',handles.main_axes)
set(handles.main_axes,'Color','none','XColor','w','YColor','w','ZColor','w')
h = rotate3d(handles.figure1);
setAllowAxesRotate(h,handles.main_axes,0)
set(handles.main_axes,'ButtonDownFcn',@(hObject,eventdata)janus3D_template_builder('down_f',hObject,eventdata,guidata(hObject)));


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
global template_builder_object

template_builder_object.current_side=template_builder_object.side_back;

template_builder_object.dim=template_builder_object.dims(3,:);
template_builder_object.set_col=1;
scatter(handles.main_axes,template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(1)),template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(2)),150,'square','filled','CData',template_builder_object.colorcode{1,1}(template_builder_object.current_side,:))
text(template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(1)),template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(2)),template_builder_object.files{1}.label(template_builder_object.current_side,:),'Parent',handles.main_axes)
set(handles.main_axes,'Color','none','XColor','w','YColor','w','ZColor','w')
h = rotate3d(handles.figure1);
setAllowAxesRotate(h,handles.main_axes,0)
set(handles.main_axes,'ButtonDownFcn',@(hObject,eventdata)janus3D_template_builder('down_f',hObject,eventdata,guidata(hObject)));



% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
global template_builder_object

template_builder_object.current_side=template_builder_object.side_top;

template_builder_object.dim=template_builder_object.dims(1,:);
template_builder_object.set_col=1;
scatter(handles.main_axes,template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(1)),template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(2)),150,'square','filled','CData',template_builder_object.colorcode{1,1}(template_builder_object.current_side,:))
text(template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(1)),template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(2)),template_builder_object.files{1}.label(template_builder_object.current_side,:),'Parent',handles.main_axes)
set(handles.main_axes,'Color','none','XColor','w','YColor','w','ZColor','w')
h = rotate3d(handles.figure1);
setAllowAxesRotate(h,handles.main_axes,0)
set(handles.main_axes,'ButtonDownFcn',@(hObject,eventdata)janus3D_template_builder('down_f',hObject,eventdata,guidata(hObject)));



% --- Executes on button press in pushbutton6.
function imp_el_Callback(hObject, eventdata, handles)
cla(handles.main_axes)
global template_builder_object

[FileName,PathName,FilterIndex] = uigetfile('*.mat','MultiSelect','on');
if PathName~=0
    
    template_builder_object.dims(1,:)=[1,2];
    template_builder_object.dims(2,:)=[2,3];
    template_builder_object.dims(3,:)=[1,3];
    if iscell(FileName)
        for n = 1:size(FileName,2)
            template_builder_object.files{n}=load([PathName,FileName{n}]);
            template_builder_object.files{n}=template_builder_object.files{n}.Electrodes.model;
        end
    else
        template_builder_object.files{1}=load([PathName,FileName]);
        template_builder_object.files{1}=template_builder_object.files{1}.Electrodes.model;
    end
    
    template_builder_object.tmp=template_builder_object.files{1}.points;
    
    template_builder_object.side_left=find(template_builder_object.tmp(:,1)<=mean(template_builder_object.tmp(:,1)));
    template_builder_object.side_right=find(template_builder_object.tmp(:,1)>mean(template_builder_object.tmp(:,1)));
    template_builder_object.side_front=find(template_builder_object.tmp(:,2)>mean(template_builder_object.tmp(:,2)));
    template_builder_object.side_back=find(template_builder_object.tmp(:,2)<=mean(template_builder_object.tmp(:,2)));
    template_builder_object.side_top=1:size(template_builder_object.tmp,1);
    template_builder_object.side_top=template_builder_object.side_top';
    template_builder_object.dim=template_builder_object.dims(1,:);
    template_builder_object.current_side=template_builder_object.side_top;
    template_builder_object.colorcode=cell(1,2);
    template_builder_object.colorcode{1,1}=repmat([0.5 0.5 0.5],size(template_builder_object.tmp,1),1);
    template_builder_object.colorcode{1,2}={template_builder_object.files{1}.label};
    scatter(handles.main_axes,template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(1)),template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(2)),150,'square','filled','CData',template_builder_object.colorcode{1,1}(template_builder_object.current_side,:))
    text(template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(1)),template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(2)),template_builder_object.files{1}.label(template_builder_object.current_side,:),'Parent',handles.main_axes)
    set(handles.main_axes,'Color','none','XColor','w','YColor','w','ZColor','w')
    h = rotate3d(handles.figure1);
    setAllowAxesRotate(h,handles.main_axes,0)
    scatter3(handles.axes4,template_builder_object.tmp(:,1),template_builder_object.tmp(:,2),template_builder_object.tmp(:,3),'square','filled','Cdata',[0.5 0.5 0.5])
    set(handles.axes4,'Color','w','XColor','w','YColor','w','ZColor','w')
    set(handles.axes4,'ButtonDownFcn',@(hObject,eventdata)janus3D_template_builder('zoom_selection',hObject,eventdata,guidata(hObject)));
    set(handles.main_axes,'ButtonDownFcn',@(hObject,eventdata)janus3D_template_builder('down_f',hObject,eventdata,guidata(hObject)));
    
end

function reset(hObject,eventdata,handles)
global template_builder_object

template_builder_object.tmp=template_builder_object.files{1}.points;
template_builder_object.side_left=find(template_builder_object.tmp(:,1)<=mean(template_builder_object.tmp(:,1)));
template_builder_object.side_right=find(template_builder_object.tmp(:,1)>mean(template_builder_object.tmp(:,1)));
template_builder_object.side_front=find(template_builder_object.tmp(:,2)>mean(template_builder_object.tmp(:,2)));
template_builder_object.side_back=find(template_builder_object.tmp(:,2)<=mean(template_builder_object.tmp(:,2)));
template_builder_object.side_top=1:size(template_builder_object.tmp,1);
template_builder_object.side_top=template_builder_object.side_top';
template_builder_object.dim=template_builder_object.dims(1,:);
template_builder_object.current_side=template_builder_object.side_top;
template_builder_object.colorcode=cell(1,2);
template_builder_object.colorcode{1,1}=repmat([0.5 0.5 0.5],size(template_builder_object.tmp,1),1);
template_builder_object.colorcode{1,2}={template_builder_object.files{1}.label};
scatter(handles.main_axes,template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(1)),template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(2)),150,'square','filled','CData',template_builder_object.colorcode{1,1}(template_builder_object.current_side,:))
text(template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(1)),template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(2)),template_builder_object.files{1}.label(template_builder_object.current_side,:),'Parent',handles.main_axes)
set(handles.main_axes,'Color','none','XColor','w','YColor','w','ZColor','w')
h = rotate3d(handles.figure1);
setAllowAxesRotate(h,handles.main_axes,0)
scatter3(handles.axes4,template_builder_object.tmp(:,1),template_builder_object.tmp(:,2),template_builder_object.tmp(:,3),'square','filled','Cdata',[0.5 0.5 0.5])
set(handles.axes4,'Color','w','XColor','w','YColor','w','ZColor','w')
set(handles.axes4,'ButtonDownFcn',@(hObject,eventdata)janus3D_template_builder('zoom_selection',hObject,eventdata,guidata(hObject)));
set(handles.main_axes,'ButtonDownFcn',@(hObject,eventdata)janus3D_template_builder('down_f',hObject,eventdata,guidata(hObject)));

function down_f(hObject,eventdata,handles)
global template_builder_object

set(handles.main_axes,'ButtonDownFcn','')
free_hand=imfreehand(handles.main_axes);
points_hand=wait(free_hand);
delete(free_hand)
if size(points_hand,1)>0
    inds_out_del=find(inpolygon(template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(1)),template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(2)),points_hand(:,1),points_hand(:,2))==1);
    template_builder_object.color=uisetcolor;
    if size(template_builder_object.color,2)>1
        template_builder_object.set_col=1;
        set(handles.axes4,'Color','w','XColor','w','YColor','w','ZColor','w')
        hold(handles.axes4,'on')
        inds_out=template_builder_object.current_side(inds_out_del,:);
        scatter3(handles.axes4,template_builder_object.tmp(inds_out,1),template_builder_object.tmp(inds_out,2),template_builder_object.tmp(inds_out,3),'square','filled','Cdata',template_builder_object.color)
        hold(handles.axes4,'off')
        set(handles.axes4,'ButtonDownFcn',@(hObject,eventdata)janus3D_template_builder('zoom_selection',hObject,eventdata,guidata(hObject)));
        
        
        template_builder_object.colorcode{1,1}(inds_out,:)=repmat(template_builder_object.color,length(inds_out),1);
        
        template_builder_object.current_side(inds_out_del,:)=[];
        template_builder_object.side_left(find(ismember(template_builder_object.side_left,inds_out)==1),:)=[];
        template_builder_object.side_right(find(ismember(template_builder_object.side_right,inds_out)==1),:)=[];
        template_builder_object.side_front(find(ismember(template_builder_object.side_front,inds_out)==1),:)=[];
        template_builder_object.side_back(find(ismember(template_builder_object.side_back,inds_out)==1),:)=[];
        template_builder_object.side_top(find(ismember(template_builder_object.side_top,inds_out)==1),:)=[];
        
        scatter(handles.main_axes,template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(1)),template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(2)),150,'square','filled','CData',template_builder_object.colorcode{1,1}(template_builder_object.current_side,:))
        text(template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(1)),template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(2)),template_builder_object.files{1}.label(template_builder_object.current_side,:),'Parent',handles.main_axes)
        set(handles.main_axes,'Color','none','XColor','w','YColor','w','ZColor','w')
        h = rotate3d(handles.figure1);
        setAllowAxesRotate(h,handles.main_axes,0)
    end
end
set(handles.main_axes,'ButtonDownFcn',@(hObject,eventdata)janus3D_template_builder('down_f',hObject,eventdata,guidata(hObject)));

function zoom_selection(hObject, eventdata, handles)
val=get(gcf,'SelectionType');
if strcmpi(val,'open')
    set(0,'Showhidden','on')
    h=figure('Units','normalized','Position',[0.25 0.25 0.5 0.5],'Toolbar','figure','menubar','none','Name',' ','NumberTitle','off','Color',[0.2 0.2 0.2]);
    copyobj(handles.axes4,h)
    set(gca,'Units','normalized','Position',[0 0 1 1],'Visible','off')
    ch = get(h,'children');
    chtags = get(ch, 'Tag');
    ftb_ind = find(strcmp(chtags, 'FigureToolBar'));
    UT = get(ch(ftb_ind),'children');
    delete(UT((end-4):end));
    delete(UT((1:7)));
end
% --- Executes on button press in pushbutton7.
function imp_col_Callback(hObject, eventdata, handles)
global template_builder_object

[FileName,PathName,FilterIndex] = uigetfile('*.mat');
if PathName~=0
    load([PathName,FileName])
    template_builder_object.colorcode=Colorscheme;
    [~,I]=tc_sortalphanum(Colorscheme{1,2}{1,1});
    [template_builder_object.files{1}.label,I2]=tc_sortalphanum(template_builder_object.files{1}.label);
    template_builder_object.files{1}.points=template_builder_object.files{1}.points(I2,:);
    template_builder_object.tmp=template_builder_object.files{1}.points;
    template_builder_object.side_left=find(template_builder_object.tmp(:,1)<=mean(template_builder_object.tmp(:,1)));
    template_builder_object.side_right=find(template_builder_object.tmp(:,1)>mean(template_builder_object.tmp(:,1)));
    template_builder_object.side_front=find(template_builder_object.tmp(:,2)>mean(template_builder_object.tmp(:,2)));
    template_builder_object.side_back=find(template_builder_object.tmp(:,2)<=mean(template_builder_object.tmp(:,2)));
    template_builder_object.side_top=1:size(template_builder_object.tmp,1);
    template_builder_object.side_top=template_builder_object.side_top';
    template_builder_object.current_side=template_builder_object.side_top;
    template_builder_object.dim=template_builder_object.dims(1,:);
    template_builder_object.colorcode{1,1}=Colorscheme{1,1}(I,:);
    template_builder_object.colorcode{1,2}={Colorscheme{1,2}{1,1}(I,:)};
    scatter3(handles.axes4,template_builder_object.tmp(:,1),template_builder_object.tmp(:,2),template_builder_object.tmp(:,3),'square','filled','Cdata',template_builder_object.colorcode{1,1})
    set(handles.axes4,'Color','w','XColor','w','YColor','w','ZColor','w')
    set(handles.axes4,'ButtonDownFcn',@(hObject,eventdata)janus3D_template_builder('zoom_selection',hObject,eventdata,guidata(hObject)));
    scatter(handles.main_axes,template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(1)),template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(2)),150,'square','filled','CData',template_builder_object.colorcode{1,1}(template_builder_object.current_side,:))
    text(template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(1)),template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(2)),template_builder_object.files{1}.label(template_builder_object.current_side,:),'Parent',handles.main_axes)
    set(handles.main_axes,'Color','none','XColor','w','YColor','w','ZColor','w')
    h = rotate3d(handles.figure1);
    setAllowAxesRotate(h,handles.main_axes,0)
    set(handles.main_axes,'ButtonDownFcn',@(hObject,eventdata)janus3D_template_builder('down_f',hObject,eventdata,guidata(hObject)));
    
end

% --- Executes on button press in pushbutton8.
function build_temp_Callback(hObject, eventdata, handles)
global template_builder_object

[FileName,PathName,FilterIndex] = uiputfile(fullfile(fileparts(which(mfilename)),'templates','*.mat'));
if PathName~=0
    template=[];
    if  isfield(template_builder_object,'template_name')
        template.type=template_builder_object.template_name;
    else
        template.type='no name';
    end
    CCode.label=[template_builder_object.colorcode{:,2}]';
    [CCode.label,I]=tc_sortalphanum(vertcat(CCode.label{:}));
    CCode.color=vertcat(template_builder_object.colorcode{:,1});
    CCode.color=CCode.color(I,:);
    
    for n=1:size(template_builder_object.files,2)
        [template_builder_object.files{n}.label,I]=tc_sortalphanum(template_builder_object.files{n}.label);
        template_builder_object.files{n}.points=template_builder_object.files{n}.points(I,:);
        if isfield(template_builder_object,'sorting_like_file')
            if ~isempty(template_builder_object.sorting_like_file)
                if iscell(template_builder_object.sorting_like_file)
                    [template_builder_object.files{n}.label,I]=tc_sortlabelslike(template_builder_object.files{n}.label,template_builder_object.sorting_like_file);
                    template_builder_object.files{n}.points=template_builder_object.files{n}.points(I,:);
                    CCode.color=CCode.color(I,:);
                end
            end
        end
        template.templates{n}.points=template_builder_object.files{n}.points;
        template.templates{n}.label=template_builder_object.files{n}.label;
        template.templates{n}.ColorCode=num2cell(CCode.color,2);
    end
    Colorscheme{1,1}=template_builder_object.colorcode{:,1};
    Colorscheme{1,2}=template_builder_object.colorcode{:,2};
    
    save([PathName,FileName],'template')
    save([PathName,'Colorscheme_',FileName],'Colorscheme')
    clc
    disp('saved.')
    close gcf
    clearvars -global template_builder_object
end


function edit1_Callback(hObject, eventdata, handles)
global template_builder_object
template_builder_object.template_name=get(hObject,'String');


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


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function TB_tag_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function help_tag_Callback(hObject, eventdata, handles)
open('janus3D_users_manual.pdf')

% --------------------------------------------------------------------
function imp_sort_Callback(hObject, eventdata, handles)
global template_builder_object
[FileName,PathName,FilterIndex]=uigetfile({'.txt';'.mat'});
if PathName~=0
    if FilterIndex==1
        fid=fopen([PathName,FileName]);
        sorting_like_file=textscan(fid,'%s','Delimiter','\n');
        fclose(fid);
        template_builder_object.sorting_like_file=sorting_like_file{1,1};
    else
        template_builder_object.sorting_like_file=load([PathName,FileName]);
        FN=fieldnames(template_builder_object.sorting_like_file);
        FN=FN{1,1};
        eval(['template_builder_object.sorting_like_file=template_builder_object.sorting_like_file.' FN ';'])
    end
end

% --------------------------------------------------------------------
function open_temp_Callback(hObject, eventdata, handles)
global template_builder_object
[template_builder_object.FileName,template_builder_object.PathName,FilterIndex]=uigetfile('.mat');
if template_builder_object.PathName~=0
    load([template_builder_object.PathName,template_builder_object.FileName])
    
    if isfield(template_builder_object,'colorcode')
        if ~isempty(template_builder_object.colorcode)
            Colorscheme=template_builder_object.colorcode;
            [~,I]=tc_sortalphanum(Colorscheme{1,2}{1,1});
            template_builder_object.colorcode{1,1}=Colorscheme{1,1}(I,:);
            template_builder_object.colorcode{1,2}={Colorscheme{1,2}{1,1}(I,:)};
        end
    end
    
    
    template_builder_object.dims(1,:)=[1,2];
    template_builder_object.dims(2,:)=[2,3];
    template_builder_object.dims(3,:)=[1,3];
    template_builder_object.tmp=template_builder_object.files{1}.points;
    
    template_builder_object.side_left=find(template_builder_object.tmp(:,1)<=mean(template_builder_object.tmp(:,1)));
    template_builder_object.side_right=find(template_builder_object.tmp(:,1)>mean(template_builder_object.tmp(:,1)));
    template_builder_object.side_front=find(template_builder_object.tmp(:,2)>mean(template_builder_object.tmp(:,2)));
    template_builder_object.side_back=find(template_builder_object.tmp(:,2)<=mean(template_builder_object.tmp(:,2)));
    template_builder_object.side_top=1:size(template_builder_object.tmp,1);
    template_builder_object.side_top=template_builder_object.side_top';
    template_builder_object.dim=template_builder_object.dims(1,:);
    template_builder_object.current_side=template_builder_object.side_top;
    scatter(handles.main_axes,template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(1)),template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(2)),150,'square','filled','CData',template_builder_object.colorcode{1,1}(template_builder_object.current_side,:))
    text(template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(1)),template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(2)),template_builder_object.files{1}.label(template_builder_object.current_side,:),'Parent',handles.main_axes)
    set(handles.main_axes,'Color','none','XColor','w','YColor','w','ZColor','w')
    h = rotate3d(handles.figure1);
    setAllowAxesRotate(h,handles.main_axes,0)
    scatter3(handles.axes4,template_builder_object.tmp(:,1),template_builder_object.tmp(:,2),template_builder_object.tmp(:,3),'square','filled','Cdata',template_builder_object.colorcode{1,1})
    set(handles.axes4,'Color','w','XColor','w','YColor','w','ZColor','w')
    set(handles.axes4,'ButtonDownFcn',@(hObject,eventdata)janus3D_template_builder('zoom_selection',hObject,eventdata,guidata(hObject)));
    set(handles.main_axes,'ButtonDownFcn',@(hObject,eventdata)janus3D_template_builder('down_f',hObject,eventdata,guidata(hObject)));
    
end

% --------------------------------------------------------------------
function save_Callback(hObject, eventdata, handles)
global template_builder_object
if ~isfield(template_builder_object,'PathName') || ~isfield(template_builder_object,'FileName')
    [template_builder_object.FileName,template_builder_object.PathName,FilterIndex]=uiputfile('.mat');
end
if template_builder_object.PathName~=0
    save([template_builder_object.PathName,template_builder_object.FileName],'template_builder_object')
end

% --------------------------------------------------------------------
function save_as_Callback(hObject, eventdata, handles)
global template_builder_object
[template_builder_object.FileName,template_builder_object.PathName,FilterIndex]=uiputfile('.mat');
if template_builder_object.PathName~=0
    save([template_builder_object.PathName,template_builder_object.FileName],'template_builder_object')
end

function figure1_DeleteFcn(hObject, eventdata, handles)
clearvars -global template_builder_object


% --------------------------------------------------------------------
function imp_temp_file_Callback(hObject, eventdata, handles)
global template_builder_object
[FileName,PathName,FilterIndex]=uigetfile({'.mat'});
if PathName~=0
    load([PathName,FileName]);
    template_builder_object.dims(1,:)=[1,2];
    template_builder_object.dims(2,:)=[2,3];
    template_builder_object.dims(3,:)=[1,3];
    
    template_builder_object.template_name=template.type;
    template_builder_object.files=template.templates;
    template_builder_object.colorcode{1,1}=cell2mat(template.templates{1,1}.ColorCode);
    template_builder_object.colorcode{1,2}={template.templates{1,1}.label};
    if isfield(template_builder_object,'colorcode')
        if ~isempty(template_builder_object.colorcode)
            Colorscheme=template_builder_object.colorcode;
            [~,I]=tc_sortalphanum(Colorscheme{1,2}{1,1});
            [template_builder_object.files{1}.label,I2]=tc_sortalphanum(template_builder_object.files{1}.label);
            template_builder_object.files{1}.points=template_builder_object.files{1}.points(I2,:);
            template_builder_object.tmp=template_builder_object.files{1}.points;
            template_builder_object.side_left=find(template_builder_object.tmp(:,1)<=mean(template_builder_object.tmp(:,1)));
            template_builder_object.side_right=find(template_builder_object.tmp(:,1)>mean(template_builder_object.tmp(:,1)));
            template_builder_object.side_front=find(template_builder_object.tmp(:,2)>mean(template_builder_object.tmp(:,2)));
            template_builder_object.side_back=find(template_builder_object.tmp(:,2)<=mean(template_builder_object.tmp(:,2)));
            template_builder_object.side_top=1:size(template_builder_object.tmp,1);
            template_builder_object.side_top=template_builder_object.side_top';
            template_builder_object.current_side=template_builder_object.side_top;
            template_builder_object.dim=template_builder_object.dims(1,:);
            template_builder_object.colorcode{1,1}=Colorscheme{1,1}(I,:);
            template_builder_object.colorcode{1,2}={Colorscheme{1,2}{1,1}(I,:)};
            scatter3(handles.axes4,template_builder_object.tmp(:,1),template_builder_object.tmp(:,2),template_builder_object.tmp(:,3),'square','filled','Cdata',template_builder_object.colorcode{1,1})
            set(handles.axes4,'Color','w','XColor','w','YColor','w','ZColor','w')
            set(handles.axes4,'ButtonDownFcn',@(hObject,eventdata)janus3D_template_builder('zoom_selection',hObject,eventdata,guidata(hObject)));
            scatter(handles.main_axes,template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(1)),template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(2)),150,'square','filled','CData',template_builder_object.colorcode{1,1}(template_builder_object.current_side,:))
            text(template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(1)),template_builder_object.tmp(template_builder_object.current_side,template_builder_object.dim(2)),template_builder_object.files{1}.label(template_builder_object.current_side,:),'Parent',handles.main_axes)
            set(handles.main_axes,'Color','none','XColor','w','YColor','w','ZColor','w')
            h = rotate3d(handles.figure1);
            setAllowAxesRotate(h,handles.main_axes,0)
            set(handles.main_axes,'ButtonDownFcn',@(hObject,eventdata)janus3D_template_builder('down_f',hObject,eventdata,guidata(hObject)));
        end
    end
end


% --------------------------------------------------------------------
function exit_fn_Callback(hObject, eventdata, handles)
clearvars -global template_builder_object
close gcf
