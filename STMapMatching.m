%This script is the main interface for map matching program: given a series
%of gps trajectory points p, and a road network G=(arc,seg), we want to
%map the GPS points to the road net work, and plot the approximated route, 
%match GPS point to segment
%params
% seg      -   n x 4 matrix representing n edges with [x1 y1 x2 y2] the start and end point
% V       -   n x 2 matrix representing intersection points between two
% roads(segs)
% T         -  GPS points to map on edges/nodes in form of m*2
%returns
% I         -   row indices for [lines;arc] for any point


function I=STMapMatching(seg,V,radius,T,n)

%matchNodes,matchEdges
matchNodes=zeros(n,1);
matchEdges=zeros(n,1);
%determin the distance from GPS points to intersection points of road
%network
[d0,ind]=verdist(V,T,radius);%n*m
for i=1:size(ind,2)%the ith GPS points
    indT=find(ind(:,i)==1);
    if length(indT)==0
        continue;
    end
    ind4GPS=min(d0(indT,i));
    matchNodes(i)=ind4GPS;
    matchEdges(i)=-1;%to denote this GPS point has been matched to a intersection vertex
end

% determine distance of any point to any edge, orthogonal to edge or
% euclidean to end points 
[d1]=csmv(seg(:,1:2),seg(:,3:4),T(:,1:2));%n*m
for i=1:size(T,1)%the ith GPS point
    if matchNodes(i)~=0
        continue;
    end
    %match to links/edges
    temp=d1(:,i);%links for the ith GPS point
    [distFL1,ind1]=min(temp);
    temp(ind1)=[];
    [distFL2,ind2]=min(temp);
    if distFL2/distFL1<=2
        continue;
    end
    matchNodes(i)=-1;%a flag which shows this GPS nodes has been matched to a edge
    matchEdges(i)=ind1;
end

j=i-1;
% determine distance of any point to any arc considering angle of arc and
% point in relation to center of arc
%match GPS point to intersection of node
%[d2]=arcdist(arc,T);

% distance of any point to any edge or arc
%d=[d1;d2];
d=d1;
clear d1;
%clear d1 d2

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
