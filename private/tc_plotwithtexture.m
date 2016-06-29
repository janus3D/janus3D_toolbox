function [ graficHandle ] = tc_plotwithtexture(V,VT,F,FT,texture )

% [ graficHandle ] = tc_plotwithtexture(V,VT,F,FT,texture )

if isstr(texture)
    texture=imread(texture);
end

coord=round(abs(round((VT).*10000)./10000).*size(texture,1));

coord(find(coord(:,1)<1),1)=ones;
coord(find(coord(:,2)<1),2)=ones;
coord(find(coord(:,1)>size(texture,1)),1)=repmat(size(texture,1),size(find(coord(:,1)>size(texture,1)),1),1);
coord(find(coord(:,2)>size(texture,1)),2)=repmat(size(texture,1),size(find(coord(:,2)>size(texture,1)),2),1);

texture_new=flipud(texture);

rgb_code=zeros(size(coord,1),3);
for n=1:size(coord,1)
    rgb_code(n,:)=texture_new(coord(n,2),coord(n,1),:);
end


color(:,1)=rgb_code(FT(:,1),1);
color(:,2)=rgb_code(FT(:,2),2);
color(:,3)=rgb_code(FT(:,3),3);

graficHandle=patch('Faces',F,'Vertices',V,'FaceVertexCData',(color)./255,'FaceColor','flat','EdgeColor','none');
%graficHandle=patch('Faces',F,'Vertices',V,'FaceVertexCData',(color)./255,'FaceColor','flat','EdgeColor','none');

end

