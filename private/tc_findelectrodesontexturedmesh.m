function [ Electrodepositions ] = tc_findelectrodesontexturedmesh( MeshStruct,texturefile,handles )

%[ Elektrodespositions ] = tc_findelectrodesontexturesmesh( MeshStruct,texturefile )
set(handles.figure1, 'pointer', 'watch')
drawnow;
if isfield(MeshStruct,'Electrodes')
    if isfield(MeshStruct.Electrodes,'points')
        Electrodepositions=MeshStruct.Electrodes.points;
    else
        Electrodepositions=[];
    end
else
    Electrodepositions=[];
end
if ischar(texturefile)
    I=imread(texturefile);
else
    I=texturefile;
end

Model=MeshStruct;
template=[];
axscaleing=200;
for t=1:5
    Model.VCoord=tc_transform3D(Model.VCoord,tc_transmat([0,0,-72]/360*2*pi,'rotate'));
    if t==1
    else
    end
    new_M{t}=Model;
end
switch_counter=1;
Model=MeshStruct;
Model.VCoord=tc_transform3D(Model.VCoord,tc_transmat([0,0,-72]/360*2*pi,'rotate'));
side=45;
for t=7:8
    Model.VCoord=tc_transform3D(Model.VCoord,tc_transmat([0,side,-72]/360*2*pi,'rotate'));
    side=0;
    new_M{t}=Model;
end


t=6;
Model=MeshStruct;
Model.VCoord=tc_transform3D(Model.VCoord,tc_transmat([45,45,-36]/360*2*pi,'rotate'));
new_M{t}=Model;

t=9;
Model=MeshStruct;
Model.VCoord=tc_transform3D(Model.VCoord,tc_transmat([45,-45,36]/360*2*pi,'rotate'));
new_M{t}=Model;

t=10;
Model=MeshStruct;
Model.VCoord=tc_transform3D(Model.VCoord,tc_transmat([45,0,0]/360*2*pi,'rotate'));
new_M{t}=Model;
set(handles.figure1, 'pointer', 'arrow')
threshold=0.5;
for n=1:10
    new_h = figure;
    set(new_h,'Position', [0, 0, 1536, 1536]);
    tc_plotwithtexture(new_M{n}.VCoord,new_M{n}.VTCoord,new_M{n}.FCoord(:,[1,3,5]),new_M{n}.FCoord(:,[2,4,6]),I);
    set(new_h.CurrentAxes,'XLim',[-axscaleing axscaleing]);
    set(new_h.CurrentAxes,'YLim',[-axscaleing axscaleing]);
    set(new_h.CurrentAxes,'ZLim',[-axscaleing axscaleing]);
    set(new_h, 'Visible', 'off');
    set(new_h.CurrentAxes,'Visible','off');
    view(0,0)
    gcas{n}=get(new_h.CurrentAxes);
    gcfs{n}=get(new_h);
    F = getframe(new_h);
    setpic{n}=F.cdata;
    [elec_sel{n},template,threshold,switch_counter]=tc_getelectrodesbytexture(setpic{n},template,threshold,switch_counter,handles);
    delete(new_h)
    if isempty(template)
        delete(findobj(get(handles.subfunparent,'Children'),'String','cancel'))
        delete(findobj(get(handles.uipanel7,'Children'),'Type','Axes','Position',[0 0 1 1]))
        return
    end
    if n==1;
        wb=waitbar(0,'estimating electrode positions...');
        set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String','estimating electrode positions...')
        drawnow;
    end
    if ~isempty(elec_sel{n})
        Proj_Points{n}=elec_sel{n};
        Proj_Points{n}(:,2)=abs(Proj_Points{n}(:,2)-gcfs{n}.Position(4));
        Proj_Points{n}(:,1)=(abs(gcas{n}.XLim(1)-gcas{n}.XLim(2)).*(Proj_Points{n}(:,1)-repmat(round(gcas{n}.Position(1)*gcfs{n}.Position(3)),size(Proj_Points{n}(:,1),1),1)))/round(gcas{n}.Position(3)*gcfs{n}.Position(3))-abs(gcas{n}.XLim(1));
        Proj_Points{n}(:,3)=(abs(gcas{n}.ZLim(1)-gcas{n}.ZLim(2)).*(Proj_Points{n}(:,2)-repmat(round(gcas{n}.Position(2)*gcfs{n}.Position(4)),size(Proj_Points{n}(:,2),1),1)))/round(gcas{n}.Position(4)*gcfs{n}.Position(4))-abs(gcas{n}.ZLim(1));
        Proj_Points{n}(:,2)=ones.*gcas{n}.YLim(1);
        Proj_Points2{n}=Proj_Points{n};
        Proj_Points2{n}(:,2)=ones.*gcas{n}.YLim(2);
        test=new_M{n}.VCoord;
        test(find(test(:,2)>0),:)=[];
        ind=knnsearch(new_M{n}.VCoord,test(knnsearch(test(:,[1,3]),Proj_Points{n}(:,[1,3])),:));
        Electrodes{n}=ind;
        Electrodes{n}=ind;
    end
    waitbar(n/10,wb);
end
delete(findobj(get(handles.subfunparent,'Children'),'String','cancel'))
delete(wb)
set(handles.figure1, 'pointer', 'arrow')
btn1 = uicontrol('Style', 'pushbutton','Units','normalized','String', 'OK',...
    'Position', [0.865 0.549 0.101 0.05],...
    'Callback', @Done_FKT,'Parent',handles.subfunparent);
[~,col]=find(template==1);
radius=round(abs(min(col)-max(col))/2);

Model=MeshStruct;
Electrodes=Model.VCoord(vertcat(Electrodes{:}),:);
SQ=squareform(pdist(Electrodes));

clear clusters
for n=1:size(SQ,1)
    clusters{n,1}= find(SQ(n,:)<radius.*0.6);
    SQ(:,clusters{n,1})=ones.*radius.*2;
end

clusters=clusters(find(cellfun('isempty',clusters)==0),:);
clear new_el
for n=1:size(clusters,1)
    new_el(n,:)=mean(Electrodes(clusters{n,1},:),1);
end

g1=subplot(1,1,1);
tc_plotwithtexture(Model.VCoord,Model.VTCoord,Model.FCoord(:,[1,3,5]),Model.FCoord(:,[2,4,6]),I);
set(gca,'Visible','off');
axis equal
hold on
s1=scatter3(new_el(:,1),new_el(:,2),new_el(:,3),'*','b');
hold off

Electrodepositions=new_el;
set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String',sprintf('found %s Electrodes\n',num2str(size(clusters,1))))
drawnow;
clc
fprintf('found %s Electrodes\n',num2str(size(clusters,1)));

btn2 = uicontrol('Style', 'pushbutton','Units','normalized','String', 'correct',...
    'Position', [0.865 0.699 0.101 0.05],...
    'Callback', @correct_el,'Parent',handles.subfunparent);

waitfor(g1)
    function Done_FKT(source,callback)
        delete(btn1)
        delete(btn2)
        delete(g1)
        delete(s1)
        set(rotate3d,'Enable','off');
        set(pan,'Enable','off');
        set(zoom,'Enable','off');
        set(gcf, 'Pointer', 'arrow');
        set (gcf, 'WindowButtonUpFcn', '');
    end

    function correct_el(source,callback)
        set(rotate3d,'Enable','off');
        set(pan,'Enable','off');
        set(zoom,'Enable','off');
        set(gcf, 'Pointer', 'circle');
        set (gcf, 'WindowButtonUpFcn', @mouseButton);
    end

    function mouseButton(source,callback)
        
        button_press = get(gcf,'selectiontype');
        val = get(gca,'CurrentPoint');
        
        if strcmpi(button_press,'normal')
            View_Points=val;
            
            rv=View_Points(1,:)-View_Points(2,:);
            pre_sel=find(pdist2(Model.VCoord,View_Points(1,:))<=mean(pdist2(Model.VCoord,View_Points(1,:))));
            lv=Model.VCoord(pre_sel,:)-repmat(View_Points(1,:),size(Model.VCoord(pre_sel,:),1),1);
            
            
            vec_prod = cross(repmat(rv,size(Model.VCoord(pre_sel,:),1),1),lv);
            vec_prod_abs=zeros(size(Model.VCoord(pre_sel,:),1),1);
            for m=1:size(Model.VCoord(pre_sel,:),1)
                vec_prod_abs(m,1) = norm(vec_prod(m,:));
            end
            dir_vec_abs = norm(rv);
            
            d = vec_prod_abs ./ dir_vec_abs;
            point=Model.VCoord(pre_sel(find(d==min(d)),1),:);
            point=point(1,:);
            
            Electrodepositions(end+1,:)=point;
            delete(s1)
            hold on
            s1=scatter3(Electrodepositions(:,1),Electrodepositions(:,2),Electrodepositions(:,3),'*','b');
            hold off
            clc
            set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String',sprintf('number of selected electrodes: %s\n',num2str(size(Electrodepositions,1))))
            drawnow;
            fprintf('number of selected electrodes: %s\n',num2str(size(Electrodepositions,1)))
            
        elseif strcmpi(button_press,'alt')
            rv=val(1,:)-val(2,:);
            lv=Electrodepositions-repmat(val(1,:),size(Electrodepositions,1),1);
            vec_prod = cross(repmat(rv,size(Electrodepositions,1),1),lv);
            vec_prod_abs=zeros(size(Electrodepositions,1),1);
            
            for m=1:size(Electrodepositions,1)
                vec_prod_abs(m,1) = norm(vec_prod(m,:));
            end
            dir_vec_abs = norm(rv);
            
            d = vec_prod_abs ./ dir_vec_abs;
            point=Electrodepositions((find(d==min(d))),:);
            point=point(1,:);
            point=knnsearch(Electrodepositions,point,'Distance','euclidean');
            point=point(1,1);
            Electrodepositions(point,:)=[];
            delete(s1)
            hold on
            s1=scatter3(Electrodepositions(:,1),Electrodepositions(:,2),Electrodepositions(:,3),'*','b');
            hold off
            
            clc
            set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String',sprintf('number of selected electrodes: %s\n',num2str(size(Electrodepositions,1))))
            drawnow;
            fprintf('number of selected electrodes: %s\n',num2str(size(Electrodepositions,1)))
        end
    end

end

