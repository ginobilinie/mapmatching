%This script is written to compute which roads the node sequence belong to
function res=computeEleNum(array)
data=unique(array);
cnt=0;
for i=1:length(data)
    num=length(find(array==data(i)));
    if num>1
        cnt=cnt+1;
        res(cnt)=data(i);
    end
end
if cnt==0
    res=array;
end
end