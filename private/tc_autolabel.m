function [ output ] = tc_autolabel( input,template,handles,MRI )
popup=[];
current_el=[];
is_labels=0;

if isfield(input,'Electrodes')
    if isfield(input.Electrodes,'label')
        output=[];
        output.label=input.Electrodes.label;
    else
        output=[];
        output.label=cell(0,0);
    end
else
    output=[];
    output.label=cell(0,0);
end
if size(template{1,1}.label,1)~=size(input.points,1)
    warning('point number mismatch - abort function')
    set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String','point number mismatch - abort function')
    drawnow;
    return
end
wb=[];
if isfield(input,'label')
    if ~isempty(input.label)
        
        label=input.label;
        input=input.points;
        a1 = axes('parent',handles.uipanel7,'Position',[0,0,1,1]);
        set (gcf, 'WindowButtonUpFcn', @mouseButton);
        set(a1,'Visible','off');
        if exist('again_btn')
            delete(again_btn)
        end
        again_btn = uicontrol('Style', 'pushbutton','Units','normalized','String', 'label again',...
            'Position', [0.865 0.599 0.101 0.05],...
            'Callback', @again_lbl,'Parent',handles.subfunparent);
        template_struct=template{1};
        general_fcn(input,template,handles,MRI,1)
    else
        input=input.points;
        general_fcn(input,template,handles,MRI,0)
    end
else
    input=input.points;
    general_fcn(input,template,handles,MRI,0)
end

    function again_lbl(source,callback)
        is_labels=0;
        cla(a1)
        general_fcn(input,template,handles,MRI,is_labels)
    end


    function general_fcn(input,template,handles,MRI,is_labels )
        
        if is_labels==0
            wb = waitbar(0,'estimating Electrodes labeling...');
            set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String','estimating Electrodes labeling...')
            drawnow;
            for t=1:size(template,2)
                template_struct=template{t};
                
                electrodepositions=input;
                
                [new,trans]=tc_SVDalign(template_struct.points,electrodepositions);
                
                electrodepositions=trans(1:3,1:3)*(electrodepositions)';
                electrodepositions=electrodepositions';
                
                Z1_temp=knnsearch(template_struct.points(:,1:2),[mean(template_struct.points(:,1)),max(template_struct.points(:,2))]);
                Z1_temp=template_struct.points(Z1_temp,:);
                
                ZX_temp=knnsearch(template_struct.points,[mean(template_struct.points(:,1)),min(template_struct.points(:,2)),min(template_struct.points(:,3))]);
                ZX_temp=template_struct.points(ZX_temp,:);
                
                Z1_new=knnsearch(electrodepositions(:,1:2),[mean(electrodepositions(:,1)),max(electrodepositions(:,2))]);
                Z1_new=electrodepositions(Z1_new,:);
                
                ZX_new=knnsearch(electrodepositions,[mean(electrodepositions(:,1)),min(electrodepositions(:,2)),min(electrodepositions(:,3))]);
                ZX_new=electrodepositions(ZX_new,:);
                
                scale=pdist2(ZX_temp,Z1_temp)/pdist2(ZX_new,Z1_new);
                
                electrodepositions=electrodepositions.*scale;
                
                ptCloudA=pointCloud(electrodepositions);
                ptCloudB=pointCloud(template_struct.points);
                
                transmat = pcregrigid(ptCloudA,ptCloudB,'Metric','PointToPlane','MaxIterations',1000,'Extrapolate', true);
                
                tmp=pctransform(pointCloud(electrodepositions),transmat);
                electrodepositions=tmp.Location;
                
                translate=(mean(template_struct.points)-mean(electrodepositions));
                electrodepositions=electrodepositions+repmat(translate,size(electrodepositions,1),1);
                
                Z1_temp=knnsearch(template_struct.points(:,1:2),[mean(template_struct.points(:,1)),max(template_struct.points(:,2))]);
                Z1_temp=template_struct.points(Z1_temp,:);
                
                Z1_new=knnsearch(electrodepositions(:,1:2),[mean(electrodepositions(:,1)),max(electrodepositions(:,2))]);
                Z1_new=electrodepositions(Z1_new,:);
                
                translate=Z1_temp-Z1_new;
                
                electrodepositions=electrodepositions+repmat(translate,size(electrodepositions,1),1);
                
                Z1_temp=knnsearch(template_struct.points(:,1:2),[mean(template_struct.points(:,1)),max(template_struct.points(:,2))]);
                Z1_temp=template_struct.points(Z1_temp,:);
                
                Z1_new=knnsearch(electrodepositions(:,1:2),[mean(electrodepositions(:,1)),max(electrodepositions(:,2))]);
                Z1_new=electrodepositions(Z1_new,:);
                
                ZX_temp=knnsearch(template_struct.points,[mean(template_struct.points(:,1)),min(template_struct.points(:,2)),min(template_struct.points(:,3))]);
                ZX_temp=template_struct.points(ZX_temp,:);
                
                ZX_new=knnsearch(electrodepositions,[mean(electrodepositions(:,1)),min(electrodepositions(:,2)),min(electrodepositions(:,3))]);
                ZX_new=electrodepositions(ZX_new,:);
                
                translate=ZX_temp-ZX_new;
                
                translate=repmat(translate,size(electrodepositions,1),1);
                
                trans_val=(pdist2(Z1_new,electrodepositions)./pdist2(ZX_new,Z1_new))';
                
                for n=1:size(electrodepositions,1)
                    translate(n,:)=translate(n,:).*trans_val(n,1);
                end
                
                electrodepositions=electrodepositions+translate;
                
                el_pos=electrodepositions;
                el_pos_temp=template_struct.points;
                
                for n=1:size(template_struct.points,1)
                    I(n,1)=knnsearch(el_pos,el_pos_temp(n,:),'Distance','euclidean');
                end
                waitbar((t/9),wb)
                res(:,t)=I;
                
            end
            
            
            [I,F]=mode(res,2);
            
            electrodes_labled=[];
            electrodes_labled.points=input;
            [C,ia]=unique(I);
            electrodes_labled.label=template_struct.label;
            electrodes_labled.label(C,:)=template_struct.label(ia,:);
            electrodes_labled.ColorCode=template_struct.ColorCode;
            electrodes_labled.ColorCode(C,:)=template_struct.ColorCode(ia,:);
            electrodes_labled.uncertainty=1-F./size(template,2);
            color=cell2mat(electrodes_labled.ColorCode);
            delete(wb)
        else
            electrodes_labled=[];
            electrodes_labled.points=input;
            electrodes_labled.label=label;
            [~,I]=tc_sortalphanum(template_struct.label);
            electrodes_labled.ColorCode=template_struct.ColorCode(I,:);
            [~,I]=tc_sortalphanum(electrodes_labled.label);
            electrodes_labled.ColorCode(I,:)=electrodes_labled.ColorCode;
            color=cell2mat(electrodes_labled.ColorCode);
            
        end
        if exist('a1')
            delete(a1)
        end
        a1 = axes('parent',handles.uipanel7,'Position',[0,0,1,1]);
        set (gcf, 'WindowButtonUpFcn', @mouseButton);
        scatter3(electrodes_labled.points(:,1),electrodes_labled.points(:,2),electrodes_labled.points(:,3),150,'filled','square','CData',color)
        text(electrodes_labled.points(:,1),electrodes_labled.points(:,2),electrodes_labled.points(:,3),electrodes_labled.label(:),'FontSize',12,'Color','w');
        set(a1,'Visible','off');
        pos = get(gcf, 'Position');
        width = pos(3);
        height = pos(4);
        clc
        if size(electrodes_labled.points,1)~=size(unique(electrodes_labled.label),1)
            set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String',sprintf('found %s electrodes and %s unique labels\n',num2str(size(electrodes_labled.points,1)),num2str(size(unique(electrodes_labled.label),1))))
            drawnow;
            warning('found %s electrodes but %s unique labels\n',num2str(size(electrodes_labled.points,1)),num2str(size(unique(electrodes_labled.label),1)));
        else
            set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String',sprintf('found %s electrodes and %s unique labels\n',num2str(size(electrodes_labled.points,1)),num2str(size(unique(electrodes_labled.label),1))))
            drawnow;
            fprintf('found %s electrodes and %s unique labels\n',num2str(size(electrodes_labled.points,1)),num2str(size(unique(electrodes_labled.label),1)));
        end
        
        if exist('done_btn')
            delete(done_btn)
        end
        done_btn = uicontrol('Style', 'pushbutton','Units','normalized','String', 'OK',...
            'Position', [0.865 0.549 0.101 0.05],...
            'Callback', @done,'Parent',handles.subfunparent);
        if exist('export_btn')
            delete(export_btn)
        end
        export_btn = uicontrol('Style', 'pushbutton','Units','normalized','String', 'export',...
            'Position', [0.865 0.499 0.101 0.05],...
            'Callback', @export,'Parent',handles.subfunparent);
        
        cancel_btn = uicontrol('Style', 'pushbutton', 'Units','normalized','String', 'cancel',...
            'Position', [0.865 0.399 0.101 0.05],...
            'Callback', @cancel_fcn,'Parent',handles.subfunparent);
        
        if exist('again_btn')
            delete(again_btn)
        end
        again_btn = uicontrol('Style', 'pushbutton','Units','normalized','String', 'label again',...
            'Position', [0.865 0.599 0.101 0.05],...
            'Callback', @again_lbl,'Parent',handles.subfunparent);
        
        function again_lbl(source,callback)
            is_labels=0;
            if exist('done_btn')
                delete(done_btn)
            end
            if exist('export_btn')
                delete(export_btn)
            end
            if exist('again_btn')
                delete(again_btn)
            end
            if exist('cancel_btn')
                delete(cancel_btn)
            end
            cla(a1)
            general_fcn(input,template,handles,MRI,is_labels)
        end
        
        function export(source, callback)
            [FileName,PathName,FilterIndex]=uiputfile('.mat');
            if PathName~=0
                Electrodes=[];
                Electrodes.points=input;
                Electrodes.label=electrodes_labled.label;
                Electrodes.model=Electrodes;
                Electrodes.MRI=Electrodes.model;
                Electrodes.MRI.points=tc_el2head(input,MRI);
                Electrodes=rmfield(Electrodes,{'points','label'});
                save([PathName,FileName],'Electrodes')
                clc
                set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String','saved.')
                drawnow;
                disp('saved.')
            end
        end
        function mouseButton(source, callback)
            if exist('current_el')
                delete(current_el)
            end
            if exist('popup')
                delete(popup)
            end
            val=get(a1,'CurrentPoint');
            rv=val(1,:)-val(2,:);
            lv=electrodes_labled.points-repmat(val(1,:),size(electrodes_labled.points,1),1);
            vec_prod = cross(repmat(rv,size(electrodes_labled.points,1),1),lv);
            vec_prod_abs=zeros(size(electrodes_labled.points,1),1);
            
            for n=1:size(electrodes_labled.points,1)
                vec_prod_abs(n,1) = norm(vec_prod(n,:));
            end
            dir_vec_abs = norm(rv);
            
            d = vec_prod_abs ./ dir_vec_abs;
            if min(d)<5
                point=electrodes_labled.points((find(d==min(d))),:);
                point=point(1,:);
                
                point2=knnsearch(electrodes_labled.points,point,'Distance','euclidean');
                if exist('current_el')
                    delete(current_el)
                end
                current_el=uicontrol('Style','text','Units','normalized',...
                    'ForeGroundColor',[1 1 1],'BackgroundColor',[0.502,0.502,0.502],'String',electrodes_labled.label{point2,:},...
                    'Position',[0.865 0.649 0.101 0.05],'Fontsize',16,'Parent',handles.subfunparent);
                
                if exist('popup')
                    delete(popup)
                end
                popup = uicontrol('Style', 'popup','Units','normalized',...
                    'String', template_struct.label,...
                    'Position', [0.865 0.725 0.101 0.075],...
                    'Callback', @set_label,'Parent',handles.subfunparent);
                
            end
            function set_label(source,callback)
                val_lab = get(source,'Value');
                new_label=template_struct.label{val_lab,1};
                new_color=template_struct.ColorCode{val_lab,1};
                electrodes_labled.label{point2,1}=new_label;
                electrodes_labled.ColorCode{point2,1}=new_color;
                color=cell2mat(electrodes_labled.ColorCode);
                [az,el]=view;
                scatter3(electrodes_labled.points(:,1),electrodes_labled.points(:,2),electrodes_labled.points(:,3),150,'filled','square','CData',color)
                text(electrodes_labled.points(:,1),electrodes_labled.points(:,2),electrodes_labled.points(:,3),electrodes_labled.label(:),'FontSize',12,'Color','w');
                view(az,el);
                set(a1,'Visible','off');
                delete(popup)
                delete(current_el)
            end
            
            
        end
        
        function cancel_fcn(source,callback)
            electrodes_labled=[];
            electrodes_labled.points=input;
            if exist('label')
                electrodes_labled.label=label;
            else
                electrodes_labled.label=cell(0,0);
            end
            done(1,1)
        end
        function done(source,callback)
            delete(a1)
            delete(done_btn)
            delete(export_btn)
            delete(again_btn)
            delete(cancel_btn)
            if exist('popup') || exist('current_el')
                delete(popup)
                delete(current_el)
            end
        end
        waitfor(a1);
    end
output=[];
output.label=electrodes_labled.label;
end