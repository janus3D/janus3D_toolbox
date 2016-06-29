function [ Model_out,Trans_new ] = tc_rearrange3D( MRI,Model_in,handles )
Model_out=Model_in;
Model_al=Model_in;
Trans=eye(4);
Trans_new=Trans;

a1=axes('parent',handles.uipanel7,'Position',[0.05,0.05,0.9,0.9],'Color',[0.502 0.502 0.502],'XColor','w','YColor','w','ZColor','w');
set(handles.figure1, 'pointer', 'watch')
set(a1,'Visible','off')
drawnow;
gg=patch('Vertices',[MRI.VCoord(:,1),MRI.VCoord(:,2),MRI.VCoord(:,3)],'Faces',MRI.FCoord(:,[1,3,5]),'EdgeColor','none','FaceColor',[241/255,223/255,185/255]);
hold on
g=patch('Vertices',[Model_al.VCoord(:,1),Model_al.VCoord(:,2),Model_al.VCoord(:,3)],'Faces',Model_al.FCoord(:,[1,3,5]),'EdgeColor','none','FaceColor',[119/255,202/255,242/255],'FaceAlpha',0.7);
xlabel('X Axis')
ylabel('Y Axis')
zlabel('Z Axis')
view(37.5*6,20)
li=camlight;

btn1 = uicontrol('Style', 'edit', 'Units','normalized','String', '0',...
    'Position', [0.875 0.799 0.025 0.025],...
    'Callback', @set_X_trans,'ButtonDownFcn', @clear,'Parent',handles.subfunparent);
btn2 = uicontrol('Style', 'edit', 'Units','normalized','String', '0',...
    'Position', [0.9 0.799 0.025 0.025],...
    'Callback', @set_Y_trans,'ButtonDownFcn', @clear,'Parent',handles.subfunparent);
btn3 = uicontrol('Style', 'edit', 'Units','normalized','String', '0',...
    'Position', [0.925 0.799 0.025 0.025],...
    'Callback', @set_Z_trans,'ButtonDownFcn', @clear,'Parent',handles.subfunparent);
mTextBox = uicontrol('style','text');
set(mTextBox,'String','T X|Y|Z');
set(mTextBox,'Units','normalized');
set(mTextBox,'ForeGroundColor',[1 1 1],'BackgroundColor',[0.502,0.502,0.502]);
set(mTextBox,'HorizontalAlignment','right');
set(mTextBox,'Position',[0.815 0.799 0.05 0.025],'Parent',handles.subfunparent);

mTextBox2 = uicontrol('style','text');
set(mTextBox2,'String','R X|Y|Z');
set(mTextBox2,'Units','normalized');
set(mTextBox2,'ForeGroundColor',[1 1 1],'BackgroundColor',[0.502,0.502,0.502]);
set(mTextBox2,'HorizontalAlignment','right');
set(mTextBox2,'Position',[0.815 0.769 0.05 0.025],'Parent',handles.subfunparent);

mTextBox3 = uicontrol('style','text');
set(mTextBox3,'String','scale');
set(mTextBox3,'Units','normalized');
set(mTextBox3,'ForeGroundColor',[1 1 1],'BackgroundColor',[0.502,0.502,0.502]);
set(mTextBox3,'HorizontalAlignment','right');
set(mTextBox3,'Position',[0.815 0.739 0.05 0.025],'Parent',handles.subfunparent);

btn4 = uicontrol('Style', 'edit', 'Units','normalized','String', '0',...
    'Position', [0.875 0.769 0.025 0.025],...
    'Callback', @rot_X,'ButtonDownFcn', @clear,'Parent',handles.subfunparent);
btn5 = uicontrol('Style', 'edit', 'Units','normalized','String', '0',...
    'Position', [0.9 0.769 0.025 0.025],...
    'Callback', @rot_Y,'ButtonDownFcn', @clear,'Parent',handles.subfunparent);
btn6 = uicontrol('Style', 'edit', 'Units','normalized','String', '0',...
    'Position', [0.925 0.769 0.025 0.025],...
    'Callback', @rot_Z,'ButtonDownFcn', @clear,'Parent',handles.subfunparent);

btn7 = uicontrol('Style', 'edit', 'Units','normalized','String', '0',...
    'Position', [0.875 0.739 0.075 0.025],...
    'Callback', @scale,'ButtonDownFcn', @clear,'Parent',handles.subfunparent);

btn8 = uicontrol('Style', 'pushbutton','Units','normalized','String', 'OK',...
    'Position', [0.865 0.549 0.101 0.05],...
    'Callback', @done,'Parent',handles.subfunparent);
btn9 = uicontrol('Style', 'pushbutton', 'Units','normalized','String', 'set light',...
    'Position', [0.865 0.649 0.101 0.05],...
    'Callback', @light,'Parent',handles.subfunparent);
cancel_btn = uicontrol('Style', 'pushbutton', 'Units','normalized','String', 'cancel',...
    'Position', [0.865 0.399 0.101 0.05],...
    'Callback', @cancel_fcn,'Parent',handles.subfunparent);

set(handles.figure1, 'pointer', 'arrow')
set(a1,'Visible','on')
axis(a1,'equal')
    function set_X_trans(source,callback)
        
        val=get(source,'String');
        Xtrans=str2num(val);
        if ~isempty(Xtrans)
            set(handles.figure1, 'pointer', 'watch')
            drawnow;
            tmp_trans=tc_transmat([Xtrans 0 0],'translate');
            Model_al.VCoord=tc_transform3D(Model_al.VCoord,tmp_trans);
            Trans=tmp_trans*Trans;
            delete(g);
            g=patch('Vertices',[Model_al.VCoord(:,1),Model_al.VCoord(:,2),Model_al.VCoord(:,3)],'Faces',Model_al.FCoord(:,[1,3,5]),'EdgeColor','none','FaceColor',[119/255,202/255,242/255],'FaceAlpha',0.7);
            set(source, 'String', '0', 'Enable', 'on');
            uicontrol(source);
            set(handles.figure1, 'pointer', 'arrow')
        end
    end
    function set_Y_trans(source,callback)
        
        val=get(source,'String');
        Ytrans=str2num(val);
        if ~isempty(Ytrans)
            set(handles.figure1, 'pointer', 'watch')
            drawnow;
            tmp_trans=tc_transmat([0 Ytrans 0],'translate');
            Model_al.VCoord=tc_transform3D(Model_al.VCoord,tmp_trans);
            Trans=tmp_trans*Trans;
            delete(g);
            g=patch('Vertices',[Model_al.VCoord(:,1),Model_al.VCoord(:,2),Model_al.VCoord(:,3)],'Faces',Model_al.FCoord(:,[1,3,5]),'EdgeColor','none','FaceColor',[119/255,202/255,242/255],'FaceAlpha',0.7);
            set(source, 'String', '0', 'Enable', 'on');
            uicontrol(source);
            set(handles.figure1, 'pointer', 'arrow')
        end
    end
    function set_Z_trans(source,callback)
        
        val=get(source,'String');
        Ztrans=str2num(val);
        if ~isempty(Ztrans)
            set(handles.figure1, 'pointer', 'watch')
            drawnow;
            tmp_trans=tc_transmat([0 0 Ztrans],'translate');
            Model_al.VCoord=tc_transform3D(Model_al.VCoord,tmp_trans);
            Trans=tmp_trans*Trans;
            delete(g);
            g=patch('Vertices',[Model_al.VCoord(:,1),Model_al.VCoord(:,2),Model_al.VCoord(:,3)],'Faces',Model_al.FCoord(:,[1,3,5]),'EdgeColor','none','FaceColor',[119/255,202/255,242/255],'FaceAlpha',0.7);
            set(source, 'String', '0', 'Enable', 'on');
            uicontrol(source);
            set(handles.figure1, 'pointer', 'arrow')
        end
    end


    function rot_X(source,callback)
        
        val=get(source,'String');
        rotX=str2num(val);
        if ~isempty(rotX)
            set(handles.figure1, 'pointer', 'watch')
            drawnow;
            tmp_trans=tc_transmat([rotX/360*2*pi 0 0],'rotate');
            Model_al.VCoord=tc_transform3D(Model_al.VCoord,tmp_trans);
            Trans=tmp_trans*Trans;
            delete(g);
            g=patch('Vertices',[Model_al.VCoord(:,1),Model_al.VCoord(:,2),Model_al.VCoord(:,3)],'Faces',Model_al.FCoord(:,[1,3,5]),'EdgeColor','none','FaceColor',[119/255,202/255,242/255],'FaceAlpha',0.7);
            set(source, 'String', '0', 'Enable', 'on');
            uicontrol(source);
            set(handles.figure1, 'pointer', 'arrow')
        end
    end
    function rot_Y(source,callback)
        
        val=get(source,'String');
        rotY=str2num(val);
        if ~isempty(rotY)
            set(handles.figure1, 'pointer', 'watch')
            drawnow;
            tmp_trans=tc_transmat([0 rotY/360*2*pi 0],'rotate');
            Model_al.VCoord=tc_transform3D(Model_al.VCoord,tmp_trans);
            Trans=tmp_trans*Trans;
            delete(g);
            g=patch('Vertices',[Model_al.VCoord(:,1),Model_al.VCoord(:,2),Model_al.VCoord(:,3)],'Faces',Model_al.FCoord(:,[1,3,5]),'EdgeColor','none','FaceColor',[119/255,202/255,242/255],'FaceAlpha',0.7);
            set(source, 'String', '0', 'Enable', 'on');
            uicontrol(source);
            set(handles.figure1, 'pointer', 'arrow')
        end
    end
    function rot_Z(source,callback)
        
        val=get(source,'String');
        rotZ=str2num(val);
        if ~isempty(rotZ)
            set(handles.figure1, 'pointer', 'watch')
            drawnow;
            tmp_trans=tc_transmat([0 0 rotZ/360*2*pi],'rotate');
            Model_al.VCoord=tc_transform3D(Model_al.VCoord,tmp_trans);
            Trans=tmp_trans*Trans;
            delete(g);
            g=patch('Vertices',[Model_al.VCoord(:,1),Model_al.VCoord(:,2),Model_al.VCoord(:,3)],'Faces',Model_al.FCoord(:,[1,3,5]),'EdgeColor','none','FaceColor',[119/255,202/255,242/255],'FaceAlpha',0.7);
            set(source, 'String', '0', 'Enable', 'on');
            uicontrol(source);
            set(handles.figure1, 'pointer', 'arrow')
        end
    end

    function scale(source,callback)
        
        val=get(source,'String');
        sca=str2num(val);
        if ~isempty(sca)
            set(handles.figure1, 'pointer', 'watch')
            drawnow;
            tmp_trans=tc_transmat([sca sca sca],'scale');
            Model_al.VCoord=tc_transform3D(Model_al.VCoord,tmp_trans);
            Trans=tmp_trans*Trans;
            delete(g);
            g=patch('Vertices',[Model_al.VCoord(:,1),Model_al.VCoord(:,2),Model_al.VCoord(:,3)],'Faces',Model_al.FCoord(:,[1,3,5]),'EdgeColor','none','FaceColor',[119/255,202/255,242/255],'FaceAlpha',0.7);
            set(source, 'String', '0', 'Enable', 'on');
            uicontrol(source);
            set(handles.figure1, 'pointer', 'arrow')
        end
    end

    function cancel_fcn(source,callback)
        Model_al=Model_in;
        done(1,1)
    end

    function clear(hObj, event) %#ok<INUSD>
        
        if ischar(hObj)==0
            return
        end
        
        set(hObj, 'String', '', 'Enable', 'on');
        uicontrol(hObj);
    end

    function done(source, callback)
        Trans_new=Trans;
        delete(g)
        delete(gg)
        delete(li)
        delete(btn1)
        delete(btn2)
        delete(btn3)
        delete(btn4)
        delete(btn5)
        delete(btn6)
        delete(btn7)
        delete(btn8)
        delete(btn9)
        delete(cancel_btn)
        delete(mTextBox)
        delete(mTextBox2)
        delete(mTextBox3)
        cla(a1)
        delete(a1)
        set(handles.figure1, 'pointer', 'arrow')
        
    end

    function light(source, callback)
        
        [az,el]=view;
        lightangle(li,az-20,30)
        
    end

waitfor(a1)
Model_out=Model_al;
end

