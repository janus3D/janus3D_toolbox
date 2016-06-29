function [ new_el ] = tc_el2head( elec_points,MRI )

MRI_points=MRI.VCoord;


for n=1:size(elec_points,1)
    Dist_Mat(:,n)=pdist2(MRI_points,elec_points(n,:));
    tmp=find(Dist_Mat(:,n)==min(Dist_Mat(:,n)));
    min_Ind(n,1)=tmp(1);
    clear tmp
    scale(n,1)=pdist2(MRI_points(min_Ind(n,1),:),[0,0,0])/pdist2(elec_points(n,:),[0,0,0]);
end

for n=1:size(elec_points,1)
    new_el(n,:)=elec_points(n,:).*scale(n,1);
end

end

