function [ Model_al_fin,transmat_new ] = tc_alignModels( MRI,Model,handles)
algorithm='PointToPoint';
blocker_fig=figure('Visible','off');
scale_ind='mean';

btn1 = uicontrol('Style', 'pushbutton','Units','normalized','String', 'select',...
    'Position', [0.865 0.549 0.101 0.05],...
    'Callback', @delete_fcn,'Parent',handles.subfunparent);

radio1 = uicontrol('Style', 'checkbox','Value',1,'Units','normalized','String', 'Point to Point',...
    'Position', [0.865 0.649 0.101 0.05],'ForeGroundColor',[1 1 1],'BackgroundColor',[0.502,0.502,0.502],...
    'Callback', @radio_point_callback,'Parent',handles.subfunparent);

radio2 = uicontrol('Style', 'checkbox','Value',0,'Units','normalized','String', 'Point to Plane',...
    'Position', [0.865 0.599 0.101 0.05],'ForeGroundColor',[1 1 1],'BackgroundColor',[0.502,0.502,0.502],...
    'Callback', @radio_plane_callback,'Parent',handles.subfunparent);

radio3 = uicontrol('Style', 'checkbox','Value',0,'Units','normalized','String', 'scale by max',...
    'Position', [0.865 0.749 0.101 0.05],'ForeGroundColor',[1 1 1],'BackgroundColor',[0.502,0.502,0.502],...
    'Callback', @radio_scale_max_callback,'Parent',handles.subfunparent);

radio4 = uicontrol('Style', 'checkbox','Value',1,'Units','normalized','String', 'scale by mean',...
    'Position', [0.865 0.699 0.101 0.05],'ForeGroundColor',[1 1 1],'BackgroundColor',[0.502,0.502,0.502],...
    'Callback', @radio_scale_mean_callback,'Parent',handles.subfunparent);

    function radio_point_callback(scr,callback)
        
        set(radio2,'Value',0)
        set(radio1,'Value',1)
        algorithm='PointToPoint';
    end

    function radio_plane_callback(scr,callback)
        
        set(radio1,'Value',0)
        set(radio2,'Value',1)
        algorithm='PointToPlane';
        
    end

    function radio_scale_mean_callback(scr,callback)
        
        set(radio3,'Value',0)
        set(radio4,'Value',1)
        scale_ind='mean';
    end

    function radio_scale_max_callback(scr,callback)
        
        set(radio4,'Value',0)
        set(radio3,'Value',1)
        scale_ind='max';
        
    end

    function delete_fcn(scr,callback)
        delete(blocker_fig)
    end

waitfor(blocker_fig)
delete(radio1)
delete(radio2)
delete(radio3)
delete(radio4)
delete(btn1)
set(handles.figure1, 'pointer', 'watch')
drawnow;
clc
set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String','processing...')
disp('processing...')
drawnow;

Model_al_tmp=Model;
Model_al_fin=Model;
transmat=eye(4);
transmat_new=transmat;
plot_var=[];

%match bounding boxes

scale(1)=dist(max(MRI.VCoord(:,1)),min(MRI.VCoord(:,1)))./dist(max(Model_al_tmp.VCoord(:,1)),min(Model_al_tmp.VCoord(:,1)));
scale(2)=dist(max(MRI.VCoord(:,2)),min(MRI.VCoord(:,2)))./dist(max(Model_al_tmp.VCoord(:,2)),min(Model_al_tmp.VCoord(:,2)));
scale(3)=dist(max(MRI.VCoord(:,3)),min(MRI.VCoord(:,3)))./dist(max(Model_al_tmp.VCoord(:,3)),min(Model_al_tmp.VCoord(:,3)));

scale=mean(scale);

Model_al_tmp.VCoord(:,4)=ones;
S_mat=tc_transmat(scale,'scale');
Model_al_tmp.VCoord=Model_al_tmp.VCoord';
Model_al_tmp.VCoord=S_mat*Model_al_tmp.VCoord;
transmat=S_mat*transmat;
Model_al_tmp.VCoord=Model_al_tmp.VCoord';
translate=mean(MRI.VCoord)-mean(Model_al_tmp.VCoord(:,1:3));
Model_al_tmp.VCoord=Model_al_tmp.VCoord';

T_mat=tc_transmat(translate,'translate');

Model_al_tmp.VCoord=T_mat*Model_al_tmp.VCoord;
Model_al_tmp.VCoord=Model_al_tmp.VCoord';
Model_al_tmp.VCoord(:,4)=[];
transmat=T_mat*transmat;

%actual co-registration

for n=1:2
    if strcmp(scale_ind,'max')
        clear scale
        scale(1)=dist(max(MRI.VCoord(MRI.Face.VInd,1)),min(MRI.VCoord(MRI.Face.VInd,1)))./dist(max(Model_al_tmp.VCoord(Model_al_tmp.Face.VInd,1)),min(Model_al_tmp.VCoord(Model_al_tmp.Face.VInd,1)));
        scale(2)=dist(max(MRI.VCoord(MRI.Face.VInd,2)),min(MRI.VCoord(MRI.Face.VInd,2)))./dist(max(Model_al_tmp.VCoord(Model_al_tmp.Face.VInd,2)),min(Model_al_tmp.VCoord(Model_al_tmp.Face.VInd,2)));
        scale(3)=dist(max(MRI.VCoord(MRI.Face.VInd,3)),min(MRI.VCoord(MRI.Face.VInd,3)))./dist(max(Model_al_tmp.VCoord(Model_al_tmp.Face.VInd,3)),min(Model_al_tmp.VCoord(Model_al_tmp.Face.VInd,3)));

        scale=mean(scale);
    else
        scale=mean(pdist2(MRI.VCoord(MRI.Face.VInd,:),mean(MRI.VCoord(MRI.Face.VInd,:))))./mean(pdist2(Model_al_tmp.VCoord(Model_al_tmp.Face.VInd,:),mean(Model_al_tmp.VCoord(Model_al_tmp.Face.VInd,:))));
        
    end
    Model_al_tmp.VCoord(:,4)=ones;
    S_mat=tc_transmat(scale,'scale');
    Model_al_tmp.VCoord=Model_al_tmp.VCoord';
    Model_al_tmp.VCoord=S_mat*Model_al_tmp.VCoord;
    transmat=S_mat*transmat;
    Model_al_tmp.VCoord=Model_al_tmp.VCoord';
    translate=mean(MRI.VCoord(MRI.Face.VInd,:))-mean(Model_al_tmp.VCoord(Model_al_tmp.Face.VInd,1:3));
    Model_al_tmp.VCoord=Model_al_tmp.VCoord';
    
    T_mat=tc_transmat(translate,'translate');
    
    Model_al_tmp.VCoord=T_mat*Model_al_tmp.VCoord;
    Model_al_tmp.VCoord=Model_al_tmp.VCoord';
    Model_al_tmp.VCoord(:,4)=[];
    transmat=T_mat*transmat;
    
    ptCloudA=pointCloud(Model_al_tmp.VCoord(Model_al_tmp.Face.VInd,:));
    ptCloudB=pointCloud(MRI.VCoord(MRI.Face.VInd,:));
    
    transmat_tmp = pcregrigid(ptCloudA,ptCloudB,'Metric',algorithm,'MaxIterations',1000,'InlierRatio',0.9);
    
    transmat_tmp=transmat_tmp.T';
    transmat=transmat_tmp*transmat;
    
    Model_al_tmp.VCoord=tc_transform3D(Model_al_tmp.VCoord,transmat_tmp);
end
a1=axes('parent',handles.uipanel7,'Position',[0.05,0.05,0.9,0.9]);
set(a1,'Visible','off')
btn1 = uicontrol('Style', 'pushbutton','Units','normalized','String', 'OK',...
    'Position', [0.865 0.549 0.101 0.05],...
    'Callback', @Done_Fcn,'Parent',handles.subfunparent);
btn2 = uicontrol('Style', 'pushbutton','Units','normalized','String', 'Cancel',...
    'Position', [0.865 0.399 0.101 0.05],...
    'Callback', @cancel,'Parent',handles.subfunparent);

plot_var(1)=patch('Vertices',[MRI.VCoord(:,1),MRI.VCoord(:,2),MRI.VCoord(:,3)],'Faces',MRI.FCoord(:,[1,3,5]),'EdgeColor','none','FaceColor',[241/255,223/255,185/255]);
hold on
plot_var(2)=patch('Vertices',[Model_al_tmp.VCoord(:,1),Model_al_tmp.VCoord(:,2),Model_al_tmp.VCoord(:,3)],'Faces',Model_al_tmp.FCoord(:,[1,3,5]),'EdgeColor','none','FaceColor',[119/255,202/255,242/255],'FaceAlpha',0.7);
view(37.5*6,20)
camlight
set(a1,'Visible','off');
axis(a1,'equal')
set(handles.figure1, 'pointer', 'arrow')
set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String','done.')
disp('done.')
drawnow;
    function Done_Fcn(source,callback)
        transmat_new=transmat;
        Model_al_fin=Model_al_tmp;
        delete(btn1)
        delete(btn2)
        delete(plot_var)
        cla(a1)
        delete(a1)
        Model_al_fin.aligned='yes';
    end

    function cancel(source,callback)
        Model_al_fin=Model;
        delete(btn1)
        delete(btn2)
        delete(plot_var)
        cla(a1)
        delete(a1)
    end
waitfor(a1)

end



