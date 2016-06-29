function [ im_new,val_ ] = tc_removebackground( im_old,area,threshold,enclosed_check_val )

%[ im_new,val_ ] = tc_removebackground( im_old,area,threshold )

img_hsv=rgb2hsv(im_old);

if size(area,1)==1 && size(area,2)==3
    val_=area;
else
    bw=poly2mask(area(:,1), area(:,2), size(im_old,1),size(im_old,2));
    
    CC = bwconncomp(bw);
    
    [~,I]=max(cellfun(@(x) numel(x),CC.PixelIdxList));
    I=I(1,1);
    sel_area=CC.PixelIdxList{I};
    
    im_r=im_old(:,:,1);
    
    im_g=im_old(:,:,2);
    
    im_b=im_old(:,:,3);
    
    val_=[];
    val_(:,:,1)=im_r(sel_area);
    val_(:,:,2)=im_g(sel_area);
    val_(:,:,3)=im_b(sel_area);
    val_=rgb2hsv(val_);
    val_=(mean(val_));
    val_=squeeze(val_)';
    
end

thresh_multi=threshold;

im_new=[];

im_new(:,:)=double(img_hsv(:,:,1))<=val_(1).*(1/thresh_multi) & double(img_hsv(:,:,1))>=val_(1).*(thresh_multi) ...
    & double(img_hsv(:,:,2))<=val_(2).*(1/thresh_multi) & double(img_hsv(:,:,2))>=val_(2).*(thresh_multi);

if ~enclosed_check_val
im_new=imfill(im_new,'holes');
end

im_new=imfill(abs(im_new-1),'holes');

CC = bwconncomp(im_new);

[~,I]=max(cellfun(@(x) numel(x),CC.PixelIdxList));

tmp=1:size(CC.PixelIdxList,2);
tmp(:,I)=[];
im_new(unique(vertcat(CC.PixelIdxList{tmp})))=0;


end

