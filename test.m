clear;
clc;
a=[0 2 4 6 8 10 12 14;0 2 1 4 6 6 5 7];  %Ҫ���ӵĵ����� x;y
[n,m]=size(a);
for i=1:m-1;
    line([a(1,i),a(1,i+1)],[a(2,i),a(2,i+1)]);  %���ӽڵ�line([x1,x2],[y1,y2])
    hold on
end
hold on
line([a(1,1),a(1,m)],[a(2,1),a(2,m)]);  %��β�ڵ�����