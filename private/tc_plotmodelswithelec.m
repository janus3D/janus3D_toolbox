function [a1] = tc_plotmodelswithelec( model,MRI,handles )
set(handles.figure1, 'pointer', 'watch')
set(gca,'Visible','off')
drawnow;
a1=axes('parent',handles.uipanel7,'Position',[0.05,0.05,0.9,0.9]);

if isfield(MRI,'VCoord') && isfield(MRI,'FCoord')
    s2=subplot(1,2,2);
    axis equal
    patch('Vertices',MRI.VCoord,'Faces',MRI.FCoord(:,[1,3,5]),'Edgecolor','none','FaceColor',[241/255,223/255,185/255]);
    camlight
    view(-180,0)
    hold on
    if isfield(model,'Electrodes_on_MRI')
        if isfield(model.Electrodes_on_MRI,'points')
            if ~isempty(model.Electrodes_on_MRI.points)
                scatter3(model.Electrodes_on_MRI.points(:,1),model.Electrodes_on_MRI.points(:,2),model.Electrodes_on_MRI.points(:,3),'filled','g');
                hold on
                if isfield(model.Electrodes_on_MRI,'label')
                    if ~isempty(model.Electrodes_on_MRI.label)
                        text(model.Electrodes_on_MRI.points(:,1).*1.05,model.Electrodes_on_MRI.points(:,2).*1.05,model.Electrodes_on_MRI.points(:,3).*1.05,model.Electrodes_on_MRI.label,'FontSize',10,'Color','w','FontWeight','bold');
                    end
                end
            end
        end
    end
    hold off
    zoom(2)
    set(gca,'Visible','off')
end
if isfield(model,'VCoord') && isfield(model,'FCoord')
    s1=subplot(1,2,1);
    axis equal
    if isfield(model,'texture')
        if ~isempty(model.texture)
            tc_plotwithtexture(model.VCoord,model.VTCoord,model.FCoord(:,[1,3,5]),model.FCoord(:,[2,4,6]),model.texture);
            view(-180,0)
            hold on
            zoom(2)
        else
            patch('Vertices',model.VCoord,'Faces',model.FCoord(:,[1,3,5]),'Edgecolor','none','FaceColor',[119/255,202/255,242/255]);
            camlight
            view(-180,0)
            hold on
            zoom(2)
        end
    end
    
    if ~isfield(model,'texture')
        patch('Vertices',model.VCoord,'Faces',model.FCoord(:,[1,3,5]),'Edgecolor','none','FaceColor',[119/255,202/255,242/255]);
        camlight
        view(-180,0)
        hold on
        zoom(2)
    end
end

if isfield(model.Electrodes,'points')
    if ~isempty(model.Electrodes.points)
        scatter3(model.Electrodes.points(:,1),model.Electrodes.points(:,2),model.Electrodes.points(:,3),'filled','g');
        hold on
        if isfield(model.Electrodes,'label')
            if ~isempty(model.Electrodes.label)
                text(model.Electrodes.points(:,1).*1.05,model.Electrodes.points(:,2).*1.05,model.Electrodes.points(:,3).*1.05,model.Electrodes.label,'FontSize',10,'Color','w','FontWeight','bold');
                clc
                set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String',sprintf('found %s electrodes and %s unique labels\n',num2str(size(model.Electrodes.points,1)),num2str(size(unique(model.Electrodes.label),1))))
                fprintf('found %s electrodes and %s unique labels\n',num2str(size(model.Electrodes.points,1)),num2str(size(unique(model.Electrodes.label),1)));
            end
        end
    end
end
if isfield(model.Electrodes,'free_selection')
    scatter3(model.Electrodes.free_selection.points(:,1),model.Electrodes.free_selection.points(:,2),model.Electrodes.free_selection.points(:,3),'filled','r');
    hold on
    text(model.Electrodes.free_selection.points(:,1).*1.05,model.Electrodes.free_selection.points(:,2).*1.05,model.Electrodes.free_selection.points(:,3).*1.05,model.Electrodes.free_selection.label,'FontSize',10,'Color','w','FontWeight','bold');
end
hold off
set(gca,'Visible','off')
btn1 = uicontrol('Style', 'pushbutton','Units','normalized','String', 'OK',...
    'Position', [0.865 0.549 0.101 0.05],...
    'Callback', @done_btn,'Parent',handles.subfunparent);
export_btn = uicontrol('Style', 'pushbutton','Units','normalized','String', 'export',...
    'Position', [0.865 0.499 0.101 0.05],...
    'Callback', @export,'Parent',handles.subfunparent);
set(handles.figure1, 'pointer', 'arrow')

    function done_btn(source,callback)
        delete(btn1)
        delete(export_btn)
        delete(a1)
        if exist('s1')
            delete(s1)
        end
        if exist('s2')
            delete(s2)
        end
    end

    function export(source, callback)
        [FileName,PathName,FilterIndex]=uiputfile('.mat');
        if PathName~=0
            Electrodes=[];
            Electrodes.model=model.Electrodes;
            if isfield(model,'Electrodes_on_MRI')
                Electrodes.MRI=model.Electrodes_on_MRI;
            end
            save([PathName,FileName],'Electrodes')
            clc
            set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String','saved.')
            drawnow;
            disp('saved.')
        end
    end
end

