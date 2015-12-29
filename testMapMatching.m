%This script is written to test MapMatching algorithm
function testMapMatching()
clear;
clc;
%1.define road network
%1.1 define segment
seg(1,:)=[0,3,1,4];
seg(2,:)=[1,4,3,4];
seg(3,:)=[3,4,3,3];
seg(4,:)=[0,3,3,3];
seg(5,:)=[0,3,1,1];
seg(6,:)=[1,1,3,1];
seg(7,:)=[3,3,3,1];
seg(8,:)=[3,3,5,3];
seg(9,:)=[5,3,5,1];
seg(10,:)=[3,1,5,1];
seg(11,:)=[5,4,5,3];
seg(12,:)=[3,4,5,4];
%define arc
for i=1:size(seg,1)
    %segment=seg(i,:);
    line([seg(i,1),seg(i,3)],[seg(i,2),seg(i,4)]);
    hold on;
end
arc(1,:)=[0,3,1,0,0];
%define trajectory
n=4;
T(1,:)=[0.1,3.5];
T(2,:)=[3,3.5];
T(3,:)=[5,2];
T(4,:)=[5,4.2];
T(5,:)=[4,1];
T(6,:)=[3,2];
plot(T(:,1),T(:,2),'r*');
hold on;
I=MapMatching(seg,arc,T,n)
mapSeg=seg(I,:);
for i=1:length(I) 
    plot([mapSeg(i,1),mapSeg(i,3)],[mapSeg(i,2),mapSeg(i,4)],'g','LineWidth',8);
end
hold off;
end