function d=distance(n1,n2)
    n=n1-n2;
    d=n(:,1).^2+n(:,2).^2;
    d=sqrt(d);
return
