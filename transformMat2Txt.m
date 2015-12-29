%store wayid information, from a mat file, and store each wayid's info in a
%txt file
function transformMat2Txt()
load('wayIDCell_30.mat','wayIDCell');
len=length(wayIDCell);
path='highways/';
for i=1:len
    [flag,orignalWayID]=isHighWay(i);
    if flag==1%here, we only care about high way
        way=wayIDCell(i);
        if isempty(way)
            continue;
        end
       
        aa=num2str(orignalWayID);
        fid=fopen([path,aa],'w');
        ways=way{1,1};
        for j=1:length(ways);
            vt=ways(j);
            time=round((vt.startTime+vt.endTime)/2);
            velo=vt.velocity;%km/h
            if isinf(velo)
                continue;
            end
            if vt.velocity>50
                continue;
            end
            fprintf(fid,'%s %g\n',num2str(time),velo);
        end
        fclose(fid);
    end
end
end