function [ Model_out,transmat_new ] = tc_prepareModel( Model_in,handles )
electrodes=[];
transmat=eye(4);
transmat_new=transmat;
canceled=0;
Model_out=Model_in;
a1=axes('parent',handles.uipanel7,'Position',[0.05,0.05,0.9,0.9]);
set(a1,'Visible','off')
set(handles.figure1, 'pointer', 'watch')
drawnow;
Model=Model_in;
if size(Model_in.FCoord,2)==3;
    tmp_F(:,[1,3,5])=Model_in.FCoord;
    Model_in.FCoord=tmp_F;
end

g=trisurf([Model_in.FCoord(:,1),Model_in.FCoord(:,3),Model_in.FCoord(:,5)],Model_in.VCoord(:,1),Model_in.VCoord(:,2),Model_in.VCoord(:,3),'EdgeColor','none','FaceColor',[119/255,202/255,242/255]);
view(37.5*6,20)
set(a1,'Visible','off');
camlight
axis(a1,'equal')

popup = uicontrol('Style', 'popup','Units','normalized',...
    'String', {'perspective','leftside','backside','topside'},...
    'Position', [0.865 0.725 0.101 0.075],...
    'Callback', @setmap,'Parent',handles.subfunparent);

btn1 = uicontrol('Style', 'pushbutton','Units','normalized','String', 'OK',...
    'Position', [0.865 0.549 0.101 0.05],...
    'Callback', @Done_FKT,'Parent',handles.subfunparent);

btn2 = uicontrol('Style', 'edit', 'String', 'set angle','Units','normalized',...
    'Position', [0.875 0.726 0.08 0.025],...
    'Callback', @set_val,'ButtonDownFcn', @clear,'Parent',handles.subfunparent);

cancel_btn = uicontrol('Style', 'pushbutton', 'String', 'cancel','Units','normalized',...
    'Position', [0.865 0.399 0.101 0.05],...
    'Callback', @cancel,'Parent',handles.subfunparent);

direction=99;
set(handles.figure1, 'pointer', 'arrow')
    function setmap(source,callbackdata)
        
        val = get(source,'Value');
        switch val
            case 1
                view(37.5*6,20)
                direction=99;
            case 2
                direction = [-1 0 0];
                view(-90,0)
            case 3
                direction = [0 -1 0];
                view(0,0)
            case 4
                direction = [0 0 1];
                view(0,90)
        end
        
    end
    function clear(hObj, event)
        
        if ischar(hObj)==0
            return
        end
        
        set(hObj, 'String', '', 'Enable', 'on');
        uicontrol(hObj);
    end

    function cancel(source,callback)
        canceled=1;
        Done_FKT(1,1)
    end

    function Done_FKT(source,callback)
        transmat_new=transmat;
        delete(g)
        delete(popup)
        delete(btn1)
        delete(btn2)
        delete(cancel_btn)
        cla(a1)
        delete(a1)
        if canceled==0
            Model_out=Model_in;
        else
            Model_out=Model;
            transmat_new=Model_in.transmat;
        end
        Model_out.positioned='yes';
    end

    function set_val(source,callback)
        
        
        
        if direction~=99;
            val=get(source,'String');
            
            rot=str2num(val);
            rotate(g,direction,rot)
            transmat_tmp=tc_transmat((rot.*direction)/360*2*pi,'rotate');
            transmat=transmat_tmp*transmat;
            Model_in.VCoord=tc_transform3D(Model_in.VCoord,transmat_tmp);
            if exist('electrodes','var')
                if isfield(electrodes,'points')
                    electrodes.points=tc_transform3D(electrodes.points,transmat_tmp);
                end
            end
        end
    end

waitfor(a1)
if canceled==1 && ~isfield(Model_in,'positioned')
    Model_out=rmfield(Model_out,'positioned');
    transmat_new=eye(4);
end
end

