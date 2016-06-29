function [ el_pos,template,threshold,switch_counter ] = tc_getelectrodesbytexture( texturefile,temp_,threshold,switch_counter,handles )
set(handles.figure1, 'pointer', 'watch')
drawnow;
el_pos=[];
template=[];
if ischar(texturefile)
    I=imread(texturefile);
else
    I=texturefile;
end


    function accept_fcn(source,callback)
        delete(done_btn)
        delete(set_threshold)
        delete(switch_btn)
    end
    function switch_fcn(source,callback)
        tmp_ax = axes('parent',handles.uipanel7,'Position',[0,0,1,1],'Visible','off');
        axes(tmp_ax);
        bw=abs(bw-1);
        bw_img=imshow(bw);
        zoom(3)
        drawnow;
        switch_counter=switch_counter+1;
        
    end
    function cancel_fcn(source,callback)
        if exist('rect_ang')
            delete(rect_ang)
        else
            delete(done_btn)
            delete(set_threshold)
            bw=rgb2gray(I);
            bw=im2bw(bw, 0.5);
        end
    end
    function set_thresh(source,callback)
        threshold = get(set_threshold, 'Value');
        bw=rgb2gray(I);
        bw=im2bw(bw, threshold);
        tmp_ax = axes('parent',handles.uipanel7,'Position',[0,0,1,1],'Visible','off');
        axes(tmp_ax);
        if ~rem(switch_counter,2)
            bw=abs(bw-1);
        end
        bw_img=imshow(bw);
        zoom(3)
        drawnow;
    end

bw=rgb2gray(I);
bw=im2bw(bw, threshold);

if isempty(temp_)
    tmp_ax = axes('parent',handles.uipanel7,'Position',[0,0,1,1],'Visible','off');
    axes(tmp_ax);
    bw_img=imshow(bw);
    zoom(3)
    set(handles.figure1, 'pointer', 'arrow')
    set_threshold = uicontrol('Style', 'slider','Units','normalized',...
        'Min',0,'Max',1,'SliderStep',[0.01 0.1],'Value',0.5,...
        'Position', [0.865 0.599 0.101 0.025],...
        'Callback', @set_thresh,'Parent',handles.subfunparent);
    
    done_btn = uicontrol('Style', 'pushbutton', 'String', 'accept','Units','normalized',...
        'Position', [0.865 0.499 0.101 0.05],...
        'Callback', @accept_fcn,'Parent',handles.subfunparent);
    cancel_btn = uicontrol('Style', 'pushbutton', 'String', 'cancel','Units','normalized',...
        'Position', [0.865 0.399 0.101 0.05],...
        'Callback', @cancel_fcn,'Parent',handles.subfunparent);
    
    switch_btn = uicontrol('Style', 'pushbutton', 'String', 'invert','Units','normalized',...
        'Position', [0.865 0.449 0.101 0.05],...
        'Callback', @switch_fcn,'Parent',handles.subfunparent);
    
    
    waitfor(done_btn)
    rect_ang=imrect(gca, [size(bw,1)/2-50,size(bw,1)/2-50,40,40]);
    setFixedAspectRatioMode(rect_ang,'true')
    rect = wait(rect_ang);
    delete(rect_ang)
    delete(cancel_btn)
    
    rect=round(rect);
    get_img=double(bw);
    if numel(rect)==0
        return
    else
        template = get_img(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3));
    end
else
    template=temp_;
end

bw=rgb2gray(I);
bw=im2bw(bw, threshold);

if ~rem(switch_counter,2)
    bw=abs(bw-1);
end

[~,col]=find(template==1);
radius=round(abs(min(col)-max(col))/2);
radius_range=[round(radius*0.8) round(radius*1.2)];

%remove maximal values
cutoff=size(find(template==1),1).*1.4;
CC = bwconncomp(bw);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
[sortedX,sortingIndices] = sort(numPixels,'descend');
max_ind=max(find(sortedX>cutoff));
for n=1:max_ind
    bw(CC.PixelIdxList{sortingIndices(n)}) = 0;
end

%remove minimal values
cutoff=size(find(template==1),1).*0.6;
CC = bwconncomp(bw);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
[sortedX,sortingIndices] = sort(numPixels);
max_ind=max(find(sortedX<cutoff));
for n=1:max_ind
    bw(CC.PixelIdxList{sortingIndices(n)}) = 0;
end

[el_pos, ~] = imfindcircles(bw,[radius_range(1) radius_range(2)], 'ObjectPolarity','bright', ...
    'Sensitivity',0.85,'Method','twostage');

end

