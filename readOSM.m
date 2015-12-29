%This script is written to read OSM file
function outfilename=readOSM()

clear;
xmlDoc = xmlread('san_fran_abstract.xml');   % ��ȡ�ļ�  test.xml

%% Extract node
nodeMap=containers.Map({-1},{-1});%map node id to sequenced id
nodeMatrix=[];%store lon, lat, information for node matrix
nodeArray = xmlDoc.getElementsByTagName('node');    % ������ID�ڵ��������IDArray
for i = 0 : nodeArray.getLength-1    % �������У� IDArray.getLength ���� 2
    thisItem=nodeArray.item(i);
    atts=thisItem.getAttributes;
    nodeid=str2num(char(atts.item(0).getValue));
    nodeMap(nodeid)=i+1;
    lon=str2num(char(atts.item(1).getValue));
    lat=str2num(char(atts.item(2).getValue));
    nodeMatrix(i+1,:)=[lon,lat];
end

%% extract the ways
wayArray = xmlDoc.getElementsByTagName('way');  %   
wayMap=containers.Map({-1},{-1});
wayNodeMatrix=[];
edgeMatrix=[];%store the edge information, n*2 form, store two nodes of a edge in a line
numEdges=0;
 for i = 0 : wayArray.getLength-1   
    thisItem = wayArray.item(i);  %    
    wayid = str2num(char(thisItem.getAttributes.item(0).getValue));   % 
    wayMap(wayid)=i+1;
    childNode = thisItem.getFirstChild ;%the first child of way node is not a real node 
    childNode = childNode.getNextSibling;     % �л�����һ���ڵ�

    prevNodeInd=-1;
    if childNode.getNodeType == childNode.ELEMENT_NODE ;    % ��鵱ǰ�ڵ�û���ӽڵ㣬  childNode.ELEMENT_NODE ����Ϊû���ӽڵ㡣
         refnodeid=str2num(char(childNode.getAttributes.item(0).getValue));
         nodeind=nodeMap(refnodeid);
         wayNodeMatrix(i+1,nodeind)=1;
         prevNodeInd=nodeind;
    end  % End IF     
    childNode = childNode.getNextSibling;     % �л�����һ���ڵ�

    while ~isempty(childNode)  % ����way�������ӽڵ㣬Ҳ���Ǳ��� ("nd") �ڵ�
      if childNode.getNodeType == childNode.ELEMENT_NODE ;    % ��鵱ǰ�ڵ�û���ӽڵ㣬  childNode.ELEMENT_NODE ����Ϊû���ӽڵ㡣
         refnodeid=str2num(char(childNode.getAttributes.item(0).getValue));
         nodeind=nodeMap(refnodeid);
         wayNodeMatrix(i+1,nodeind)=1;
         numEdges=numEdges+1;
         if prevNodeInd==-1
             fprintf('wrong prevNodeInd\n');
         end
         edgeMatrix(numEdges,:)=[prevNodeInd,nodeind];
         prevNodeInd=nodeind;
      end  % End IF         
     childNode = childNode.getNextSibling;     % �л�����һ���ڵ�
  end  % End WHILE   
 end
 outfilename='sanfran_abstract.mat';
 save(outfilename,'nodeMap','wayMap','wayNodeMatrix','nodeMatrix','edgeMatrix');
end