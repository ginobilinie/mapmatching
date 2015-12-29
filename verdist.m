%This script is written to compute distance from any trajectory points to any vertexs
%params
%V: vertex in roadnetwork in n*2 form
%T: GPS trajetory points in m*2 form
%radius: determine the distance which is within radius area based on the
%intersection points
%output
%d: distance from any trajectory points to any vertex in n*m form
%ind: the index for intersection points which stay within the circle of the
%GPS points  in form of n*m
function [d,ind]=verdist(V,T,radius)
dx=repmat(V(:,1),1,size(T,1))-repmat(T(:,1)',size(V,1),1);
dy=repmat(V(:,2),1,size(T,1))-repmat(T(:,2)',size(V,1),1);
d=sqrt(dx.^2+dy.^2);
ind=d<=radius;
end