function [ pointcloudmove_new,trans ] = tc_SVDalign( pointcloudstatic,pointcloudmove )

% regid transform of 2 pointclouds using SVD based on PCA
% use as:[ pointcloudmove_new,trans ] = tc_SVDalign( pointcloudstatic,pointcloudmove )

scale=mean(pdist2(pointcloudstatic,(mean(pointcloudstatic))))./mean(pdist2(pointcloudmove,(mean(pointcloudmove))));
pointcloudmove=pointcloudmove.*scale;

translate=mean(pointcloudstatic)-mean(pointcloudmove);
new_M=pointcloudmove+repmat(translate,size(pointcloudmove,1),1);

PCA_M=pca(new_M);
PCA_MR=pca(pointcloudstatic);

H = PCA_M'*PCA_MR ;

[U,S,V] = svd(H);

R = V*U';

new_new_M=R*new_M';
new_new_M=new_new_M';

translate2=mean(pointcloudstatic,1)-mean(new_new_M,1);

trans=R;
trans(1:3,4)=translate2';
trans(4,1:3)=[scale,scale,scale];
trans(4,4)=1;

pointcloudmove_new=R*pointcloudmove';
pointcloudmove_new=pointcloudmove_new';
pointcloudmove_new=pointcloudmove_new+repmat(trans(1:3,4)',size(pointcloudmove,1),1);

end

