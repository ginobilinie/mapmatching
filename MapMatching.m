%This script is the main interface for map matching program: given a series
%of gps trajectory points p, and a road network G=(arc,line), we want to
%map the GPS points to the road net work, and plot the approximated route, 
%match GPS point to segment
%params
% line      -   n x 4 matrix representing n edges with [x1 y1 x2 y2] the start and end point
% arc       -   n x 5 matrix representing [xcenter ycenter radius
%               start_angle end_angle]
% p         -   points to map on edges and arcs
%returns
% I         -   row indices for [lines;arc] for any point


function I=MapMatching(line,arc,p,n)
% determine distance of any point to any edge, orthogonal to edge or
% euclidean to end points 

[d1]=csmv(line(:,1:2),line(:,3:4),p(:,1:2));

% determine distance of any point to any arc considering angle of arc and
% point in relation to center of arc
%match GPS point to intersection of node
[d2]=arcdist(arc,p);

% distance of any point to any edge or arc
%d=[d1;d2];
d=d1;
clear d1 d2

% weighted distance of 3+n points, that the minimum of 3+n points becomes
% the criteria for edge or arc detection see fig.4

%calculate the sum of candidates points along the path using topological
%inoformation
d2=[d(:,2:end) zeros(size(d,1),1)];
d1=[zeros(size(d,1),1) d(:,1:end-1)];
%The problem is that there will be non-connected edges/arcs in the road is
%some situation. The reason is that the point is the is only to computhe
%sum of neighbouring shortest distance from points to segments
d_weight=d+[d(:,2:end) zeros(size(d,1),1)]+[zeros(size(d,1),1) d(:,1:end-1)];
[mini I]=min(d_weight,[],1);

%to choose the point one by one, 
% for i=1:n
%    d_weight=d+d1+d2;
% end;
%choose the shortest one
