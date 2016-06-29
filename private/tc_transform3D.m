function [ points_out ] = tc_transform3D(points_in,transmat)

%input is a mx3 matrix containing 3D points and a 4x4 transformation matrix
%output is a mx3 matrix containing transformed 3D points
if size(points_in,2)==3 && size(transmat,1)==4 && size(transmat,2)==4
    points_in(:,4)=ones;
    points_in=points_in';
    points_in=transmat*points_in;
    points_in=points_in';
    points_in(:,4)=[];
    
    points_out=points_in;
else
    error('input must be a mx3 point cloud and a 4x4 transformation matrix')
end
end

