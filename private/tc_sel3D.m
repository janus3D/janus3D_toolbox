function [ Electrodes,texture_img ] = tc_sel3D( Model,texture_img,MRI,handles )
View_Points=[];
sel_labels=[];
elec=1;
if isfield(Model,'Electrodes')
    Electrodes=Model.Electrodes;
else
    Electrodes=[];
end
val_callback=[];
foldercontent=dir(fileparts(which(mfilename)));
foldercontent={foldercontent(:,1).name}';
has_temp=find(strcmp(foldercontent,'current_cap_template.mat')==1);
if size(has_temp,1)>0 || ~isempty(sel_labels)
    sel_type='guide';
    load('current_cap_template.mat')
    template=template.templates;
    sel_labels=template{1,1}.label;
    clear template
    set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String',['set ',sel_labels{elec,1}])
    drawnow;
    disp(['set ',sel_labels{elec,1}])
else
    sel_type='free';
end
counter=0;
fs=[];
tf=[];
elc_mat=[];
elc_mat.points=[];
elc_mat.label=[];
elc_mat.free_selection.points=[];
elc_mat.free_selection.label=[];
t=[];
tc=[];
s=[];
li=[];
test_texture=texture_img;
set(handles.figure1, 'pointer', 'watch')
a1=axes('parent',handles.uipanel7,'Position',[0.05,0.05,0.9,0.9]);
set(a1,'Visible','off')
axis(a1,'equal')
drawnow;


if ~isfield(Model,'Electrodes')
    Model.Electrodes=[];
    Model.Electrodes.points=[];
    Model.Electrodes.label=[];
end

if isempty(texture_img)
    g=patch('Faces',Model.FCoord(:,[1,3,5]),'Vertices',Model.VCoord,'EdgeColor','none','FaceColor',[119/255,202/255,242/255]);
    view(180,0)
    li=camlight;
else
    g=tc_plotwithtexture(Model.VCoord,Model.VTCoord,Model.FCoord(:,[1,3,5]),Model.FCoord(:,[2,4,6]),texture_img);
    view(180,0)
end


if isfield(Model.Electrodes,'points')
    if ~isempty(Model.Electrodes.points)
        hold on
        scatter3(Model.Electrodes.points(:,1),Model.Electrodes.points(:,2),Model.Electrodes.points(:,3),'filled','g');
        if isfield(Model.Electrodes,'label')
            if ~isempty(Model.Electrodes.label)
                text(Model.Electrodes.points(:,1).*1.05,Model.Electrodes.points(:,2).*1.05,Model.Electrodes.points(:,3).*1.05,Model.Electrodes.label,'FontSize',10,'Color','w','FontWeight','bold');
                clc
                set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String',sprintf('found %s electrodes and %s unique labels\n',num2str(size(Model.Electrodes.points,1)),num2str(size(unique(Model.Electrodes.label),1))))
                fprintf('found %s electrodes and %s unique labels\n',num2str(size(Model.Electrodes.points,1)),num2str(size(unique(Model.Electrodes.label),1)));
            end
        end
    end
end
if isfield(Model.Electrodes,'free_selection')
    scatter3(Model.Electrodes.free_selection.points(:,1),Model.Electrodes.free_selection.points(:,2),Model.Electrodes.free_selection.points(:,3),'filled','r');
    hold on
    text(Model.Electrodes.free_selection.points(:,1).*1.05,Model.Electrodes.free_selection.points(:,2).*1.05,Model.Electrodes.free_selection.points(:,3).*1.05,Model.Electrodes.free_selection.label,'FontSize',10,'Color','w','FontWeight','bold');
end
hold off




set(a1,'Visible','off');
hold on
set (gcf, 'WindowButtonUpFcn', @mouseButton);
if isempty(texture_img)
    btn1 = uicontrol('Style', 'pushbutton','Units','normalized','String', 'set texture',...
        'Position', [0.865 0.749 0.101 0.05],...
        'Callback', @texture,'Parent',handles.subfunparent);
    
    btn2 = uicontrol('Style', 'pushbutton','Units','normalized','String', 'set light',...
        'Position', [0.865 0.699 0.101 0.05],...
        'Callback',  @light,'Parent',handles.subfunparent);
end
btn3a = uicontrol('Style', 'pushbutton','Units','normalized','String', 'replace',...
    'Position', [0.865 0.549 0.05 0.05],...
    'Callback',  @donea,'Parent',handles.subfunparent);

btn3b = uicontrol('Style', 'pushbutton','Units','normalized','String', 'add',...
    'Position', [0.915 0.549 0.05 0.05],...
    'Callback',  @doneb,'Parent',handles.subfunparent);

btn4 = uicontrol('Style', 'pushbutton','Units','normalized','String', 'free',...
    'Position', [0.865 0.649 0.05 0.05],...
    'Callback',  @free_sel,'Parent',handles.subfunparent);

btn5 = uicontrol('Style', 'pushbutton','Units','normalized','String', 'guided',...
    'Position', [0.915 0.649 0.05 0.05],...
    'Callback',  @guide_sel,'Parent',handles.subfunparent);

merge_btn = uicontrol('Style', 'pushbutton','Units','normalized','String', 'merge',...
    'Position', [0.865 0.499 0.101 0.05],...
    'Callback', @merge_fcn,'Parent',handles.subfunparent);
export_btn = uicontrol('Style', 'pushbutton','Units','normalized','String', 'export',...
    'Position', [0.865 0.449 0.101 0.05],...
    'Callback', @export,'Parent',handles.subfunparent);
clear_btn = uicontrol('Style', 'pushbutton','Units','normalized','String', 'clear all',...
    'Position', [0.865 0.399 0.101 0.05],...
    'Callback', @clear_elc,'Parent',handles.subfunparent);
cancel_btn = uicontrol('Style', 'pushbutton', 'Units','normalized','String', 'cancel',...
    'Position', [0.865 0.349 0.101 0.05],...
    'Callback', @cancel_fcn,'Parent',handles.subfunparent);

if size(has_temp,1)>0 || ~isempty(sel_labels)
    elec_string=sel_labels{elec,1};
    tc=uicontrol('Style','text','Units','normalized','ForeGroundColor',[1 1 1],'BackgroundColor',[0.502,0.502,0.502],'String',elec_string,...
        'Position',[0.865 0.599 0.101 0.05],'Fontsize',16,'Parent',handles.subfunparent);
end
hold off
set(gcf, 'Pointer', 'circle');
    function light(source, callback)
        
        [az,el]=view;
        lightangle(li,az-20,30)
        
    end
    function merge_fcn(source,callback)
        elc_mat.points=vertcat(elc_mat.points,elc_mat.free_selection.points);
        elc_mat.label=vertcat(elc_mat.label,elc_mat.free_selection.label);
        elc_mat.free_selection.points=[];
        elc_mat.free_selection.label=[];
        if isfield(Model,'Electrodes')
            elc_mat.points=vertcat(elc_mat.points,Model.Electrodes.points);
            elc_mat.label=vertcat(elc_mat.label,Model.Electrodes.label);
            if isfield(Model.Electrodes,'free_selection')
                elc_mat.points=vertcat(elc_mat.points,Model.Electrodes.free_selection.points);
                elc_mat.label=vertcat(elc_mat.label,Model.Electrodes.free_selection.label);
                Model.Electrodes=rmfield(Model.Electrodes,'free_selection');
            end
        end
        
        
        cla(a1)
        if isempty(texture_img)
            g=patch('Faces',Model.FCoord(:,[1,3,5]),'Vertices',Model.VCoord,'EdgeColor','none','FaceColor',[119/255,202/255,242/255]);
            li=camlight;
        else
            g=tc_plotwithtexture(Model.VCoord,Model.VTCoord,Model.FCoord(:,[1,3,5]),Model.FCoord(:,[2,4,6]),texture_img);
        end
        hold on
        scatter3(elc_mat.points(:,1),elc_mat.points(:,2),elc_mat.points(:,3),'*','g');
        text(elc_mat.points(:,1).*1.05,elc_mat.points(:,2).*1.05,elc_mat.points(:,3).*1.05,elc_mat.label,'Color','w','FontWeight','bold');
        hold off
        
    end
    function export(source, callback)
        set(handles.figure1, 'pointer', 'arrow')
        [FileName,PathName,FilterIndex]=uiputfile('.mat');
        if PathName~=0
            if isempty(elc_mat.points) && ~isempty(elc_mat.free_selection.points)
                Electrodes=Model.Electrodes;
                Electrodes.free_selection=elc_mat.free_selection;
            elseif ~isempty(elc_mat.points) && isempty(elc_mat.free_selection.points)
                Electrodes=Model.Electrodes;
                Electrodes.points=elc_mat.points;
                Electrodes.label=elc_mat.label;
            elseif ~isempty(elc_mat.points) && ~isempty(elc_mat.free_selection.points)
                Electrodes=elc_mat;
            else
                Electrodes=Model.Electrodes;
            end
            
            if isfield(Electrodes,'free_selection')
                if isempty(Electrodes.free_selection.points)
                    Electrodes=rmfield(Electrodes,'free_selection');
                end
            end
            tmp=Electrodes;
            Electrodes=[];
            Electrodes.model=tmp;
            Electrodes_on_MRI=tmp;
            if isfield(Electrodes_on_MRI,'free_selection')
                Electrodes_on_MRI=rmfield(Electrodes_on_MRI,'free_selection');
            end
            if  isfield(Electrodes_on_MRI,'points')
                Electrodes_on_MRI.points=tc_el2head(Electrodes.model.points,MRI);
            end
            Electrodes.MRI.points=Electrodes_on_MRI.points;
            Electrodes.MRI.label=Electrodes_on_MRI.label;
            save([PathName,FileName],'Electrodes')
            clc
            set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String','saved.')
            drawnow;
            disp('saved.')
            
        end
    end
    function donea(source, callback)
        
        delete(g)
        if isempty(elc_mat.points) && ~isempty(elc_mat.free_selection.points)
            Electrodes=Model.Electrodes;
            Electrodes.free_selection=elc_mat.free_selection;
        elseif ~isempty(elc_mat.points) && isempty(elc_mat.free_selection.points)
            Electrodes=Model.Electrodes;
            Electrodes.points=elc_mat.points;
            Electrodes.label=elc_mat.label;
        elseif ~isempty(elc_mat.points) && ~isempty(elc_mat.free_selection.points)
            Electrodes=elc_mat;
        else
            Electrodes=Model.Electrodes;
        end
        
        if isfield(Electrodes,'free_selection')
            if isempty(Electrodes.free_selection.points)
                Electrodes=rmfield(Electrodes,'free_selection');
            end
        end
        if isempty(test_texture)
            delete(btn1)
            delete(btn2)
        end
        delete(btn3a)
        delete(btn3b)
        delete(btn5)
        delete(clear_btn)
        delete(merge_btn)
        delete(cancel_btn)
        cla(a1)
        delete(a1)
        if exist('val_callback')
            delete(val_callback)
        end
        if exist('tc')
            delete(tc)
        end
        delete(btn4)
        delete(export_btn)
        set(rotate3d,'Enable','off');
        set(pan,'Enable','off');
        set(zoom,'Enable','off');
        set(gcf,'WindowButtonUpFcn','');
        set(gcf, 'Pointer', 'arrow');
    end
    function doneb(source, callback)
        
        delete(g)
        if isempty(elc_mat.points) && ~isempty(elc_mat.free_selection.points)
            Electrodes=Model.Electrodes;
            if isfield(Model.Electrodes,'free_selection')
                Electrodes.free_selection.points=vertcat(Model.Electrodes.free_selection.points,elc_mat.free_selection.points);
                Electrodes.free_selection.label=vertcat(Model.Electrodes.free_selection.label,elc_mat.free_selection.label);
            else
                Electrodes.free_selection=elc_mat.free_selection;
            end
        elseif ~isempty(elc_mat.points) && isempty(elc_mat.free_selection.points)
            Electrodes=Model.Electrodes;
            if isfield(Model.Electrodes,'points')
                Electrodes.points=vertcat(Model.Electrodes.points,elc_mat.points);
                Electrodes.label=vertcat(Model.Electrodes.label,elc_mat.label);
            else
                Electrodes.points=elc_mat.points;
                Electrodes.label=elc_mat.label;
            end
        elseif ~isempty(elc_mat.points) && ~isempty(elc_mat.free_selection.points)
            if isfield(Model.Electrodes,'points')
                Electrodes.points=vertcat(Model.Electrodes.points,elc_mat.points);
                Electrodes.label=vertcat(Model.Electrodes.label,elc_mat.label);
            else
                Electrodes.points=elc_mat.points;
                Electrodes.label=elc_mat.label;
            end
            if isfield(Model.Electrodes,'free_selection')
                Electrodes.free_selection.points=vertcat(Model.Electrodes.free_selection.points,elc_mat.free_selection.points);
                Electrodes.free_selection.label=vertcat(Model.Electrodes.free_selection.label,elc_mat.free_selection.label);
            else
                Electrodes.free_selection=elc_mat.free_selection;
            end
        else
            Electrodes=Model.Electrodes;
        end
        
        if isfield(Electrodes,'free_selection')
            if isempty(Electrodes.free_selection.points)
                Electrodes=rmfield(Electrodes,'free_selection');
            end
        end
        if isempty(test_texture)
            delete(btn1)
            delete(btn2)
        end
        delete(btn3a)
        delete(btn3b)
        delete(btn5)
        delete(merge_btn)
        delete(cancel_btn)
        delete(clear_btn)
        cla(a1)
        delete(a1)
        if exist('val_callback')
            delete(val_callback)
        end
        if exist('tc')
            delete(tc)
        end
        delete(btn4)
        delete(export_btn)
        set(rotate3d,'Enable','off');
        set(pan,'Enable','off');
        set(zoom,'Enable','off');
        set(gcf,'WindowButtonUpFcn','');
        set(gcf, 'Pointer', 'arrow');
    end

    function cancel_fcn(source,callback)
        delete(g)
        if isfield(Model,'Electrodes')
            Electrodes=Model.Electrodes;
        else
            Electrodes=[];
        end
        if isempty(test_texture)
            delete(btn1)
            delete(btn2)
        end
        delete(btn3a)
        delete(btn3b)
        delete(btn5)
        delete(clear_btn)
        delete(merge_btn)
        delete(cancel_btn)
        cla(a1)
        delete(a1)
        if exist('val_callback')
            delete(val_callback)
        end
        if exist('tc')
            delete(tc)
        end
        delete(btn4)
        delete(export_btn)
        set(rotate3d,'Enable','off');
        set(pan,'Enable','off');
        set(zoom,'Enable','off');
        set(gcf,'WindowButtonUpFcn','');
        set(gcf, 'Pointer', 'arrow');
    end

    function clear_elc(source, callback)
        Electrodes=[];
        elc_mat=[];
        elc_mat.points=[];
        elc_mat.label=[];
        elc_mat.free_selection.points=[];
        elc_mat.free_selection.label=[];
        Model.Electrodes.points=[];
        Model.Electrodes.label=[];
        Model.Electrodes.free_selection.points=[];
        Model.Electrodes.free_selection.label=[];
        elec=1;
        cla(a1)
        if ~isempty(sel_labels)
            elec_string=sel_labels{elec,1};
            set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String',['set ',sel_labels{elec,1}])
            if exist('tc')
                delete(tc)
            end
            tc=uicontrol('Style','text','Units','normalized','ForeGroundColor',[1 1 1],'BackgroundColor',[0.502,0.502,0.502],'String',elec_string,...
                'Position',[0.865 0.599 0.101 0.05],'Fontsize',16,'Parent',handles.subfunparent);
            drawnow;
            clc
            disp(['set ',sel_labels{elec,1}])
        end
        
        if isempty(texture_img)
            g=patch('Faces',Model.FCoord(:,[1,3,5]),'Vertices',Model.VCoord,'EdgeColor','none','FaceColor',[119/255,202/255,242/255]);
            li=camlight;
        else
            g=tc_plotwithtexture(Model.VCoord,Model.VTCoord,Model.FCoord(:,[1,3,5]),Model.FCoord(:,[2,4,6]),texture_img);
        end
        set(gcf,'WindowButtonUpFcn',@mouseButton);
        set(gcf, 'Pointer', 'circle');
    end
    function texture(source, callback)
        
        
        [FileName,PathName,FilterIndex]=uigetfile('.jpg');
        
        if PathName~=0
            set(handles.figure1, 'pointer', 'watch')
        set(a1,'Visible','off')
        drawnow;
        texture_img=imread([PathName,FileName]);
        delete(li)
        tc_plotwithtexture(Model.VCoord,Model.VTCoord,Model.FCoord(:,[1,3,5]),Model.FCoord(:,[2,4,6]),texture_img);
        delete(btn1)
        delete(btn2)
        end
        set(handles.figure1, 'pointer', 'circle')
    end

    function guide_sel(source,callback)
        if size(has_temp,1)>0 || ~isempty(sel_labels)
            sel_type='guide';
            set(val_callback,'Visible','off')
            if exist('tc')
                delete(tc)
            end
            
            tc=uicontrol('Style','text','Units','normalized','ForeGroundColor',[1 1 1],'BackgroundColor',[0.502,0.502,0.502],'String',elec_string,...
                'Position',[0.865 0.599 0.101 0.05],'Fontsize',16,'Parent',handles.subfunparent);
            set(tc,'Visible','on')
            drawnow;
            
        else
            [FileName,PathName,FilterIndex]=uigetfile({'.txt';'.mat'});
            if PathName~=0
                if FilterIndex==1
                    fid=fopen([PathName,FileName]);
                    sorting_like_file=textscan(fid,'%s','Delimiter','\n');
                    fclose(fid);
                    sel_labels=sorting_like_file{1,1};
                else
                    elec_string_file=load([PathName,FileName]);
                    FN=fieldnames(elec_string_file);
                    FN=FN{1,1};
                    eval(['sel_labels=elec_string_file.' FN ';'])
                end
                sel_type='guide';
            else
                return
            end
            elec_string=sel_labels{elec,1};
            tc=uicontrol('Style','text','Units','normalized','ForeGroundColor',[1 1 1],'BackgroundColor',[0.502,0.502,0.502],'String',elec_string,...
                'Position',[0.865 0.599 0.101 0.05],'Fontsize',16,'Parent',handles.subfunparent);
            set(tc,'Visible','on')
            drawnow;
        end
        
    end

    function free_sel(source,callback)
        sel_type='free';
        set(tc,'Visible','off')
        val_callback=uicontrol('Style','edit','Units','normalized','BackgroundColor',[1,1,1],'String','',...
            'Position',[0.865 0.613 0.101 0.025],'callback',@val_edit_callback,'Parent',handles.subfunparent);
        drawnow;
        function val_edit_callback(source,callback)
            if counter>0
                elc_mat.free_selection.label{counter,1}=get(source,'String');
                tf(counter)=text(elc_mat.free_selection.points(counter,1).*1.05,elc_mat.free_selection.points(counter,2).*1.05,elc_mat.free_selection.points(counter,3).*1.05,['\bf ' elc_mat.free_selection.label{counter,1}],'Color','w');
            end
            set(val_callback,'String','')
            
        end
    end

    function mouseButton(source,callback)
        
        button_press = get(gcf,'selectiontype');
        if strcmpi(button_press,'normal')
            
            View_Points=get(a1,'CurrentPoint');
            clc
            
            rv=View_Points(1,:)-View_Points(2,:);
            pre_sel=find(pdist2(Model.VCoord,View_Points(1,:))<=mean(pdist2(Model.VCoord,View_Points(1,:))));
            lv=Model.VCoord(pre_sel,:)-repmat(View_Points(1,:),size(Model.VCoord(pre_sel,:),1),1);
            
            
            vektorprodukt = cross(repmat(rv,size(Model.VCoord(pre_sel,:),1),1),lv);
            betrag_vektorprodukt=zeros(size(Model.VCoord(pre_sel,:),1),1);
            for n=1:size(Model.VCoord(pre_sel,:),1)
                betrag_vektorprodukt(n,1) = norm(vektorprodukt(n,:));
            end
            betrag_richtungsVek = norm(rv);
            
            d = betrag_vektorprodukt ./ betrag_richtungsVek;
            point=Model.VCoord(pre_sel(find(d==min(d)),1),:);
            point=point(1,:);
            if strcmpi(sel_type,'guide')
                set(val_callback,'Visible','off')
                set(tc,'Visible','on')
                drawnow;
                elc_mat.label{elec,1}=sel_labels{elec,1};
                t(elec)=text(point(1,1).*1.05,point(1,2).*1.05,point(1,3).*1.05,['\bf ' elc_mat.label{elec,1}],'Color','w');
                
                elc_mat.points(elec,:)=point;
                
                hold on
                s(elec)=scatter3(point(1),point(2),point(3),'*','g');
                hold off
                
                if elec<size(sel_labels,1)
                    elec=elec+1;
                end
                elec_string=sel_labels{elec,1};
                if exist('tc')
                    delete(tc)
                end
                tc=uicontrol('Style','text','Units','normalized','ForeGroundColor',[1 1 1],'BackgroundColor',[0.502,0.502,0.502],'String',elec_string,...
                    'Position',[0.865 0.599 0.101 0.05],'Fontsize',16,'Parent',handles.subfunparent);
                set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String',['set ',sel_labels{elec,1}])
                drawnow;
                disp(['set ',sel_labels{elec,1}])
            else
                counter=counter+1;
                set(tc,'Visible','off')
                elc_mat.free_selection.points(counter,:)=point;
                elc_mat.free_selection.label{counter,1}='';
                set(val_callback,'Visible','on')
                drawnow;
                hold on
                fs(counter)=scatter3(point(1),point(2),point(3),'*','r');
                tf(counter)=text(elc_mat.free_selection.points(counter,1).*1.05,elc_mat.free_selection.points(counter,2).*1.05,elc_mat.free_selection.points(counter,3).*1.05,['\bf ' elc_mat.free_selection.label{counter,1}],'Color','w');
                hold off
                
            end
        elseif strcmpi(button_press,'alt')
            if strcmpi(sel_type,'guide')
                set(tc,'Visible','on')
                set(val_callback,'Visible','off')
                drawnow;
                if elec>1
                    elec=elec-1;
                    clc
                    set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String',['set ',sel_labels{elec,1}])
                    drawnow;
                    disp(['set ',sel_labels{elec,1}])
                    delete(t(elec))
                    delete(s(elec))
                    elc_mat.points(elec,:)=[];
                    elc_mat.label(elec,:)=[];
                    elec_string=sel_labels{elec,1};
                    if exist('tc')
                        delete(tc)
                    end
                    tc=uicontrol('Style','text','Units','normalized','ForeGroundColor',[1 1 1],'BackgroundColor',[0.502,0.502,0.502],'String',elec_string,...
                        'Position',[0.865 0.599 0.101 0.05],'Fontsize',16,'Parent',handles.subfunparent);
                    drawnow;
                end
                
            else
                set(tc,'Visible','off')
                set(val_callback,'Visible','on','String','')
                drawnow;
                if counter>0
                    clc
                    delete(fs(counter))
                    delete(tf(counter))
                    elc_mat.free_selection.points(counter,:)=[];
                    elc_mat.free_selection.label(counter,:)=[];
                    counter=counter-1;
                end
            end
        end
    end

waitfor(a1)
set(handles.figure1, 'pointer', 'arrow')

end

