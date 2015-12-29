function computeVelocity4HighWayNetwork()
clear;
clc;
load('sanfran_abstract.mat','nodeMap','nodeMatrix','wayMap','wayNodeMatrix','edgeMatrix');

numEdges=size(edgeMatrix,1);
%now I want to produce a sparse matrix
m=size(edgeMatrix,1);
n=size(edgeMatrix,1);
nodeInd1=edgeMatrix(:,1);
nodeInd2=edgeMatrix(:,2);
nodes1=nodeMatrix(nodeInd1,:);
nodes2=nodeMatrix(nodeInd2,:);
dis=distance(nodes1,nodes2);
graph = sparse(nodeInd1,nodeInd2,dis,m,n);
for i=1:numEdges
    nodeInd1=edgeMatrix(i,1);
    nodeInd2=edgeMatrix(i,2);
    node1=nodeMatrix(nodeInd1,:);%coordinates
    node2=nodeMatrix(nodeInd2,:);
    seg(i,:)=[node1,node2];
end

for i=1:size(seg,1)
    %segment=seg(i,:);
    line([seg(i,1),seg(i,3)],[seg(i,2),seg(i,4)]);
    hold on;
end
arc(1,:)=[0,3,1,0,0];
%define trajectory
dirname='Traces_0418';
childdirs=dir(dirname);

numWays=length(wayMap)-1;

wayIDCell=cell(numWays,1);

for dd=5:length(childdirs)%the first 4 are not real directory
cdirname=childdirs(dd).name;
files=dir([dirname '/' cdirname]);%files in child directory
for ff=3:length(files)
tic;
%inputfile='abboip_1';
inputfile=[dirname '/' cdirname '/' files(ff).name];
Traces=load(inputfile);
T=Traces(:,1:2);
n=size(T,1);

plot(T(:,1),T(:,2),'r*');
hold on;
I=MapMatching(seg,arc,T,n);%return the index of chosen segments
%now use dijstra algorithm to connect unconnected roads
numEdges=length(I);


for i=1:numEdges-1
    prevEdge=seg(I(i),:);
    currEdge=seg(I(i+1),:);
    prevTime=Traces(i,3);
    currTime=Traces(i+1,3);
    prevDis=distance(prevEdge(1:2),prevEdge(3:4));
    currDis=distance(currEdge(1:2),currEdge(3:4));
    plot([prevEdge(1),prevEdge(3)],[prevEdge(2),prevEdge(4)],'g','LineWidth',2);
    plot([currEdge(1),currEdge(3)],[currEdge(2),currEdge(4)],'g','LineWidth',2);
    prevEdgeInd=edgeMatrix(I(i),:);
    currEdgeInd=edgeMatrix(I(i+1),:);
    [node1,node2]=getClosestNodes(prevEdge,currEdge);
    sourceInd=-1;targetInd=-1;
    if node1==nodeMatrix(prevEdgeInd(1),:)
        sourceInd=prevEdgeInd(1);
    elseif node1==nodeMatrix(prevEdgeInd(2),:)
        sourceInd=prevEdgeInd(2);
    else
        fprintf('node error\n');
    end
    if node2==nodeMatrix(currEdgeInd(1),:)
        targetInd=currEdgeInd(1);
    elseif node2==nodeMatrix(currEdgeInd(2),:)
        targetInd=currEdgeInd(2);
    else
        fprintf('node error\n');
    end
    
    stways=wayNodeMatrix(:,[sourceInd,targetInd]);
    [rows,cols,vals]=find(stways==1);
    stWayIDs=rows;
    if length(stWayIDs)==0
        continue;
    end
    flag=0;
    for tt=1:length(stWayIDs)
        if isHighWay(stWayIDs(tt))
            flag=1;
            break;
        end
    end
    if flag==0
        continue;
    end
    [path cost] = dijkstra(graph,sourceInd,targetInd);
    dis=cost+(prevDis+currDis)/2;
    velocity=dis/(currTime-prevTime);
    %find the road IDs corresponding to the node ids on this interval, and
    %label this road as this velocity
    %nodesOfInterval=[sourceInd,path,targetInd];
    nodesOfInterval=path;
    nodesOfInterval(length(path)+1)=sourceInd;
    nodesOfInterval(length(path)+2)=targetInd;

    wayIDs=[];
    ways=wayNodeMatrix(:,nodesOfInterval);
    [rows,cols,vals]=find(ways==1);
%     for col=1:size(ways,2)%how many ways concerned
%         wayIDs=find(ways(:,col)==1);
%     end
    wayIDs=rows;
    correctWayIDs=computeEleNum(wayIDs);
    wayIDs=correctWayIDs;
    vt.velocity=velocity;
    vt.startTime=prevTime;
    vt.endTime=currTime;
    
    
    for k=1:length(wayIDs)
        wid=wayIDs(k);
        if isempty(wayIDCell{wid})
            wayIDCell{wid}=[vt];
        else
            temp=wayIDCell{wid};
            ll=length(temp);
            temp(ll+1)=vt;
            wayIDCell{wid}=temp;
        end
    end
    %VeloTimeMap(
    %plot(nodeMatrix(path,1),nodeMatrix(path,2),'g','LineWidth',2);
end
toc;
% mapSeg=seg(I,:);
% for i=1:length(I) 
%     plot([mapSeg(i,1),mapSeg(i,3)],[mapSeg(i,2),mapSeg(i,4)],'g','LineWidth',4);
% end
end
if mod(dd,10)==0
    save(sprintf('wayIDCell_%d.mat',dd),'wayIDCell');
end

end
hold off;
save('wayIDCell.mat','wayIDCell');
%saveas(gcf,[inputfile, '.png']);
end


