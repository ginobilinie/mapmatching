%This script is written to compute the closest nodes from two edges
%params
%prevEdge: two nodes
%currEdge: two nodes
%return
%node1,node2
function   [node1,node2]= getClosestNodes(prevEdge,currEdge)
    n11=prevEdge(1:2);n12=prevEdge(3:4);
    n21=currEdge(1:2);n22=currEdge(3:4);
    d11=distance(n11,n21);
    d12=distance(n11,n22);
    d21=distance(n12,n21);
    d22=distance(n12,n22);
    d=[d11,d12,d21,d22];
    [mind,ind]=min(d);
    switch ind
        case 1
            node1=n11;
            node2=n21;
        case 2
            node1=n11;
            node2=n22;
        case 3
            node1=n12;
            node2=n21;
        case 4
            node1=n12;
            node2=n22;
    end
return

