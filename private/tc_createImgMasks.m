function [  ] = tc_createImgMasks( handles )
a1=axes('parent',handles.uipanel7,'Position',[0.05,0.05,0.9,0.9]);
set(a1,'Visible','off');
files=[];
path_=[];
thresh_type='area';
enclosed_check_val=0;
path_mask=[];
thresh=0.5;
bg=[];
enclosed_check=[];
mask_val=[];
sub_p_1=[];
sub_p_2=[];
files_new=[];
btn_auto_thresh=[];
btn_bg_thresh=[];
slider_=[];
imgfold_txt=[];
bg_txt=[];
maskfold_txt=[];
sel_free=[];
%%% select image folder%%%
if exist('btn_img_folder')
    delete(btn_img_folder)
end
btn_img_folder = uicontrol('Style', 'pushbutton', 'Units','normalized','String', 'image folder',...
    'Position', [0.865 0.749 0.101 0.05],...
    'Callback', @img_folder,'Parent',handles.subfunparent);
if exist('btn_mask_folder')
    delete(btn_mask_folder)
end
btn_mask_folder = uicontrol('Style', 'pushbutton', 'Units','normalized','String', 'mask folder',...
    'Position', [0.865 0.699 0.101 0.05],...
    'Callback', @mask_folder,'Parent',handles.subfunparent);
if exist('btn_mask_create')
    delete(btn_mask_create)
end
btn_mask_create = uicontrol('Style', 'pushbutton','Units','normalized','String', 'create masks',...
    'Position', [0.865 0.499 0.101 0.05],...
    'Callback', @create,'Parent',handles.subfunparent,'Enable','off');

%%% select output/masks folder%%%

    function img_folder(varargin)
        path_=uigetdir;
        if path_~=0
            path_=[path_ ,filesep];
            files=dir(path_);
            counter=0;
            clc
            set(handles.figure1, 'pointer', 'watch')
            set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String','loading images...')
            drawnow;
            disp('loading images...')
            for n=1:size(dir(path_),1)
                if strfind(lower(files(n,1).name),'.jpg')
                    counter=counter+1;
                    files_new{counter,1}=files(n,1).name;
                end
            end
            sub_p_1=subplot(2,1,1);
            I{1,1}=imread([path_,files_new{1,1}]);
            imshow(imread([path_,files_new{1,1}]));
            sub_p_2=subplot(2,1,2);
            mask=zeros(size(I{1,1},1),size(I{1,1},2));
            imshow(mask)
            if exist('slider_')
                delete(slider_)
            end
            slider_ = uicontrol('Style','slider','Units','normalized',...
                'Position',[0.865 0.648 0.101 0.05],'String','select threshold','Min',0,'Max',1,'SliderStep',[1/256 0.1],'Value',thresh,...
                'Callback',@slider_fcn,'Parent',handles.subfunparent,'Enable','off');
            if exist('btn_auto_thresh')
                delete(btn_auto_thresh)
            end
            btn_auto_thresh = uicontrol('Style', 'pushbutton', 'Units','normalized','String', 'by color',...
                'Position', [0.865 0.599 0.101 0.05],...
                'Callback', @auto_thresh,'Parent',handles.subfunparent);
            
            btn_bg_thresh = uicontrol('Style', 'pushbutton', 'Units','normalized','String', 'by image',...
                'Position', [0.865 0.549 0.101 0.05],...
                'Callback', @bg_thresh,'Parent',handles.subfunparent);
            enclosed_check = uicontrol('Style', 'checkbox', 'Units','normalized','String', 'enclosed',...
                'Position', [0.865 0.449 0.101 0.05],'ForegroundColor','w','BackgroundColor',[0.502 0.502 0.502],...
                'Value',enclosed_check_val,'Callback',@change_check,'Parent',handles.subfunparent);
            
            img_path=strsplit(path_, filesep);
            img_path=['~' filesep img_path{1,end-1}];
            if exist('imgfold_txt')
                delete(imgfold_txt)
            end
            imgfold_txt=uicontrol('Style','text','Units','normalized','Position',[0.765 0.764 0.100 0.02],'HorizontalAlignment','right','ForegroundColor','w','BackgroundColor',[0.502 0.502 0.502],'String',img_path,'Parent',handles.subfunparent);
            delete(handles.text9)
            delete(handles.text10)
            set(handles.figure1, 'pointer', 'arrow')
            set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String','done.')
            drawnow;
            disp('done.')
            if (~isempty(sel_free)||~isempty(bg)) && ~isempty(path_) && ~isempty(path_mask)
                set(btn_mask_create,'Enable','on')
            end
        end
        
        function change_check(varargin)
            enclosed_check_val=get(enclosed_check, 'Value');
        end
        
        function auto_thresh (varargin)
            free_=imfreehand(sub_p_1);
            sel_free=round(wait(free_)./10).*10;
            delete(free_)
            drawnow;
            if size(sel_free,1)>0
                thresh_type='area';
                set(handles.figure1, 'pointer', 'watch')
                drawnow;
                [mask,mask_val]  = tc_removebackground( I{1,1},sel_free,0.5,enclosed_check_val );
                imshow(mask,'Parent',sub_p_2)
                set(handles.figure1, 'pointer', 'arrow')
                set(slider_,'Enable','on')
            end
            if (~isempty(sel_free)||~isempty(bg)) && ~isempty(path_) && ~isempty(path_mask)
                set(btn_mask_create,'Enable','on')
            end
        end
        
        function bg_thresh(varargin)
            [bg_name,path_bg]=uigetfile('.jpg');
            if path_bg~=0
                thresh_type='bg';
                set(handles.figure1, 'pointer', 'watch')
                drawnow;
                bg=imread([path_bg,bg_name]);
                [mask]  = tc_maskbybg( I{1,1},bg,5);
                imshow(mask,'Parent',sub_p_2)
                set(handles.figure1, 'pointer', 'arrow')
                set(slider_,'Enable','on')
                set(slider_,'Value',0.05)
                bg_txt=uicontrol('Style','text','Units','normalized','Position',[0.765 0.569 0.100 0.02],'HorizontalAlignment','right','ForegroundColor','w','BackgroundColor',[0.502 0.502 0.502],'String',bg_name,'Parent',handles.subfunparent);

                if (~isempty(sel_free)||~isempty(bg)) && ~isempty(path_) && ~isempty(path_mask)
                    set(btn_mask_create,'Enable','on')
                end
            end
        end
        
        function slider_fcn (varargin)
            
            slider_val = get(slider_, 'Value');
            switch thresh_type
                case 'area'
                    thresh=slider_val;
                    set(handles.figure1, 'pointer', 'watch')
                    drawnow;
                    mask  = tc_removebackground( I{1,1},mask_val,thresh,enclosed_check_val );
                    imshow(mask,'Parent',sub_p_2)
                    set(handles.figure1, 'pointer', 'arrow')
                case'bg'
                    thresh=slider_val*100;
                    set(handles.figure1, 'pointer', 'watch')
                    drawnow;
                    mask  = tc_maskbybg( I{1,1},bg,thresh );
                    imshow(mask,'Parent',sub_p_2)
                    set(handles.figure1, 'pointer', 'arrow')
            end
            
        end
        
        
    end
    function mask_folder(varargin)
        
        path_mask=uigetdir;
        if path_mask~=0
            path_mask=[path_mask ,filesep];
            mask_path=strsplit(path_mask, filesep);
            mask_path=['~' filesep mask_path{1,end-1}];
            if exist('maskfold_txt')
                delete(maskfold_txt)
            end
            maskfold_txt=uicontrol('Style','text','Units','normalized','Position',[0.765 0.714 0.100 0.02],'HorizontalAlignment','right','ForegroundColor','w','BackgroundColor',[0.502 0.502 0.502],'String',mask_path,'Parent',handles.subfunparent);
        end
        if (~isempty(sel_free)||~isempty(bg)) && ~isempty(path_) && ~isempty(path_mask)
            set(btn_mask_create,'Enable','on')
        end
    end

    function create(varargin)
        files=dir(path_);
        counter=0;
        clear files_new
        set(handles.figure1, 'pointer', 'watch')
        clc
        set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String','processing images...')
        drawnow;
        disp('processing images...')
        waitb=waitbar(0,'processing images...');
        for n=1:size(dir(path_),1)
            
            if strfind(lower(files(n,1).name),'.jpg')
                switch thresh_type
                    case 'area'
                        counter=counter+1;
                        files_new{counter,1}=files(n,1).name;
                        I=imread([path_,files_new{counter,1}]);
                        mask  = tc_removebackground(I,mask_val,thresh,enclosed_check_val );
                        masks{counter,1}=mask;
                    case 'bg'
                        counter=counter+1;
                        files_new{counter,1}=files(n,1).name;
                        I=imread([path_,files_new{counter,1}]);
                        mask  = tc_maskbybg( I,bg,thresh);
                        masks{counter,1}=mask;
                end
            end
            done_val=n/size(dir(path_),1)*100;
            waitbar(done_val/100,waitb,'processing images...')
            clc
            set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String','processing images...')
            drawnow;
            disp('processing images...')
        end
        %%%saving%%%
        clc
        set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String','saving images...')
        drawnow;
        disp('saving images...')
        waitbar(0,waitb,'saving images...')
        files_to_save=files_new;
        files_to_save(:,2)=masks;
        for n=1:size(files_new,1)
            files_to_save{n,1}(:,end-3:end)=[];
            files_to_save{n,1}=[files_to_save{n,1}(1,:) , '_mask'];
            imwrite(files_to_save{n,2},[path_mask files_to_save{n,1} '.png'])
            done_val=n/size(files_new,1)*100;
            clc
            set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String','saving images...')
            drawnow;
            disp('saving images...')
            waitbar(done_val/100,waitb,'saving images...')
        end
        set(findobj(get(handles.subfunparent,'Children'),'tag','status_handler'),'String','done.')
        drawnow;
        disp('done.')
        delete(sub_p_1)
        delete(sub_p_2)
        delete(imgfold_txt)
        delete(maskfold_txt)
        delete(bg_txt)
        delete(btn_auto_thresh)
        delete(btn_img_folder)
        delete(btn_mask_folder)
        delete(btn_mask_create)
        delete(btn_bg_thresh)
        delete(slider_)
        delete(enclosed_check)
        delete(a1)
        delete(waitb)
        set(handles.figure1, 'pointer', 'arrow')
    end

end

