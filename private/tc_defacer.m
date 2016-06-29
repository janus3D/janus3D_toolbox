function [ Model_out ] = tc_defacer( Model_in,is_shape,color,handles )
Cut_m=[];
count=0;
P=[];
Model=Model_in;
Model_out=Model_in;
is_enab_get_point=0;
Point_Mat=[];
plothandle=[];
set(handles.figure1, 'pointer', 'watch')
a1=axes('parent',handles.uipanel7,'Position',[0.05,0.05,0.9,0.9]);
set(a1,'Visible','off')
drawnow;
if isfield(Model_in,'pnt') && isfield(Model_in,'tri') && ~isfield(Model_in,'VCoord') && ~isfield(Model_in,'FCoord')
    Model_in.VCoord=Model_in.pnt;
    Model_in.FCoord(:,[1,3,5])=Model_in.tri;
end

scale_val_center=[mean(Model_in.VCoord(:,1)),mean(Model_in.VCoord(:,2)),mean(Model_in.VCoord(:,3))];

scale_val=max(max(abs(Model_in.VCoord-repmat([mean(Model_in.VCoord(:,1)),mean(Model_in.VCoord(:,2)),mean(Model_in.VCoord(:,3))],size(Model_in.VCoord,1),1)))).*1.1;

set(gcf,'WindowButtonUpFcn',@(src,evnt)printPos());

plot_var=trisurf([Model_in.FCoord(:,1),Model_in.FCoord(:,3),Model_in.FCoord(:,5)],Model_in.VCoord(:,1),Model_in.VCoord(:,2),Model_in.VCoord(:,3),'EdgeColor','none','FaceColor',color);
view(-90,0)
set(a1,'Visible','off');

axis(a1,'equal')
camlight
xlim([scale_val_center(1)-scale_val scale_val_center(1)+scale_val]);
ylim([scale_val_center(2)-scale_val scale_val_center(2)+scale_val]);
zlim([scale_val_center(3)-scale_val scale_val_center(3)+scale_val]);
tc_viewbox(a1,'w');



btn1 = uicontrol('Style', 'pushbutton','Units','normalized','String', 'OK',...
    'Position', [0.865 0.549 0.101 0.05],...
    'Callback', @Done_FKT,'Parent',handles.subfunparent);

popup = uicontrol('Style', 'popup','Units','normalized',...
    'String', {'side view','perspective'},...
    'Position', [0.865 0.725 0.101 0.075],...
    'Callback', @setmap,'Parent',handles.subfunparent);

btn4 = uicontrol('Style', 'pushbutton','Units','normalized','String','select by shape',...
    'Position', [0.865 0.699 0.101 0.05],...
    'Callback', @shape,'Parent',handles.subfunparent);
btn_point = uicontrol('Style', 'pushbutton','Units','normalized','String', 'select by points',...
    'Position', [0.865 0.649 0.101 0.05],...
    'Callback', @get_ginput,'Parent',handles.subfunparent);

cancel_btn = uicontrol('Style', 'pushbutton', 'String', 'cancel','Units','normalized',...
    'Position', [0.865 0.399 0.101 0.05],...
    'Callback', @cancel,'Parent',handles.subfunparent);

if isempty(is_shape)
    set(btn4,'Enable','off')
end
set(handles.figure1, 'pointer', 'arrow')
    function shape(source,callback)
        
        delete(P)
        xLimits = get(a1,'XLim');
        prescale=((max(Model_in.VCoord(:,1))-min(Model_in.VCoord(:,1)))/(max(is_shape(:,1))-min(is_shape(:,1))));
        Point_Mat=tc_pointcloudtocursor(is_shape,prescale/3);
        
        plane_vec1=Point_Mat;
        xdist=diff(xLimits);
        plane_vec2=Point_Mat;
        plane_vec2(:,1)=plane_vec2(:,1)+repmat(xdist,size(Point_Mat,1),1);
        
        verts=zeros(size([plane_vec1;plane_vec2]));
        verts(1:2:end-1,:)=plane_vec1;
        verts(2:2:end,:)=plane_vec2;
        Face_Sort=1:((size(verts,1)/2)-1)*2;
        Face_Sort=Face_Sort';
        faces=[Face_Sort Face_Sort+1 Face_Sort+2];
        faces(end+1,:)=[1 2 size(verts,1)];
        faces(end+1,:)=[1 size(verts,1) size(verts,1)-1];
        P=[];
    end


    function cancel(source,callback)
        Model_out=Model;
        Done_FKT(1,1)
    end

    function Done_FKT(source,callback)
        set(handles.figure1, 'pointer', 'watch')
        set(a1,'Visible','off')
        drawnow;
        delete(plot_var)
        delete(btn1)
        delete(popup)
        delete(btn4)
        delete(btn_point)
        delete(plothandle)
        delete(cancel_btn)
        cla(a1)
        delete(a1)
        set(rotate3d,'Enable','off');
        set(pan,'Enable','off');
        set(zoom,'Enable','off');
        set(gcf,'WindowButtonUpFcn','');
    end


    function setmap(source,callback)
        
        val=get(source,'Value');
        if val==2
            view(37.5*6,20)
        end
        if val==1
            view(-90,0)
        end
    end

    function printPos
        
        clickedPt = get(a1,'CurrentPoint');
        point2d =[clickedPt(1,:) 1]';
        if rem(is_enab_get_point,2)
            count=count+1;
            Point_Mat(count,:)=point2d(1:3);
            
            
            hold on
            if exist('Point_Mat','var')~=0
                
                P(count)=plot3(Point_Mat(:,1),Point_Mat(:,2),Point_Mat(:,3),'*','Color','g');
                set(P(count),'Visible','on')
            end
        else
            hold off
            
        end
    end

    function get_ginput(source,callback)
        
        
        
        val=get(source,'Value');
        if val==1
            is_enab_get_point=is_enab_get_point+1;
            if (rem(is_enab_get_point,2)==0 && is_enab_get_point>1 && size(Point_Mat,1)>1)
                delete(Cut_m);
                plane_vec1=Point_Mat;
                xLimits = get(a1,'XLim');
                xdist=diff(xLimits);
                plane_vec2=Point_Mat;
                plane_vec2(:,1)=plane_vec2(:,1)+repmat(xdist,size(Point_Mat,1),1);
                clear Point_Mat
                Point_Mat=[];
                count=0;
                
                verts=zeros(size([plane_vec1;plane_vec2]));
                verts(1:2:end-1,:)=plane_vec1;
                verts(2:2:end,:)=plane_vec2;
                Face_Sort=1:((size(verts,1)/2)-1)*2;
                Face_Sort=Face_Sort';
                faces=[Face_Sort Face_Sort+1 Face_Sort+2];
                faces(end+1,:)=[1 2 size(verts,1)];
                faces(end+1,:)=[1 size(verts,1) size(verts,1)-1];
                hold on
                Cut_m=patch('Faces',faces(1:end-2,:),'Vertices',verts,'FaceColor','g','FaceAlpha',0.5,'EdgeColor','none');
                set(a1,'Visible','off');
                hold off
                delete(P);
                P=[];
            end
        end
        
        
    end

Model_out=Model_in;

waitfor(plot_var);

if exist('verts','var')
    Cut_Model.VCoord=verts;
    Cut_Model.FCoord=faces;
    Model_out.Cut_Model=Cut_Model;
    
    test=Model_out.VCoord;
    poly=Model_out.Cut_Model.VCoord(2:2:end,:);
    
    test_dim(1)=sum(abs(poly(:,1)-poly(1,1)));
    test_dim(2)=sum(abs(poly(:,2)-poly(1,2)));
    test_dim(3)=sum(abs(poly(:,3)-poly(1,3)));
    
    dim_del=find(test_dim==0);
    
    test(:,dim_del)=[];
    poly(:,dim_del)=[];
    in = find(inpolygon(test(:,1),test(:,2),poly(:,1),poly(:,2))==1);
    in2 = find(inpolygon(test(:,1),test(:,2),poly(:,1),poly(:,2))==0);
    
    
    Model_out.Face.VInd=in;
    Model_out.Face.FCoord=Model_out.FCoord(find(ismember(ismember(Model_out.FCoord(:,[1,3,5]),in),[1,1,1],'rows')==1),:);
    Model_out.nonFace.VInd=in2;
    Model_out.nonFace.FCoord=Model_out.FCoord(find(ismember(ismember(Model_out.FCoord(:,[1,3,5]),in2),[1,1,1],'rows')==1),:);
    
    
end
set(handles.figure1, 'pointer', 'arrow')
end

