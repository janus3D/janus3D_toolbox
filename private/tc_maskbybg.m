function [ mask ] = tc_maskbybg( image,backgroundimage,tolerance )

%[ mask ] = tc_maskbybg( image,backgroundimage,tolerance )
%
%creates a mask by substracting the background image using a tolerance in %

mask=abs((backgroundimage(:,:,1)<=image(:,:,1).*(1+tolerance/100) & backgroundimage(:,:,1)>=image(:,:,1).*(1-tolerance/100) & ...
    backgroundimage(:,:,2)<=image(:,:,2).*(1+tolerance/100) & backgroundimage(:,:,2)>=image(:,:,2).*(1-tolerance/100) & ...
    backgroundimage(:,:,3)<=image(:,:,3).*(1+tolerance/100) & backgroundimage(:,:,3)>=image(:,:,3).*(1-tolerance/100))-1);

mask=imfill(mask,'holes');

end

