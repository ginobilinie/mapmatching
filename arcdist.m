%This script is written to compute distance from any GPS point to any arc
%center (intersection of segments)...determine distance of any point to any arc center

%params
% arc       -   n x 5 matrix representing [xcenter ycenter radius start_angle end_angle]
% p         -   points to map on edges and arcs
%returns
% d         -   squared distance from any point to any arc

function [d]=arcdist(arc,p)
dx=repmat(arc(:,1),1,size(p,1))-repmat(p(:,1)',size(arc,1),1);
dy=repmat(arc(:,2),1,size(p,1))-repmat(p(:,2)',size(arc,1),1);
d=sqrt(dx.^2+dy.^2);%the distance between any point to any arc center
d=(d-repmat(arc(:,3),1,size(d,2))).^2;%here is ?/

% determine angle of any point to any arc center
alpha=atan(dy./dx);

% clean 360 degree instead of radians from -pi/2 - pi/2 refering to atan()
log=-dy<=0 & pi/2>=alpha & alpha>0;
alpha(log)=alpha(log)+pi;

log=-dx<=0 & -pi/2<=alpha & alpha<=0;
alpha(log)=alpha(log)+pi;

log=-dx>=0 & -pi/2<=alpha & alpha<=0;
alpha(log)=alpha(log)+2*pi;

alpha=rad2deg(alpha);
beta=rad2deg(arc(:,4:5));

% all points outside the range of angle of arc are hardly excluded
% distance  is set to inf
log1=alpha>=repmat(beta(:,1),1,size(p,1)) & alpha<=repmat(beta(:,2),1,size(p,1));%the angles in the range are thought to be ok.
d(~log1)=inf;%otherwise it is thought to be infinite