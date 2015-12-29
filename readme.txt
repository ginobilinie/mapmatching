This project is to match GPS points onto digital maps, a very interesting project. In this task, the idea is mainly match them to the shortest route, and also we take topology information into consideration (for the adjacent points, we should choose a shortest way (time or distance) instead of just mapping into shortest route). There are also other considerations, if you are interested, please contact me, we can discuss.

Run environment:
1.Windows, matlab2012b or higher
2. codes is all written by me, so there is no libarary dependencies.

How to run code:
1.test a trace for map-matching, just run mainMapMatching.m
2.I visualize the matching retsult directly in mainMapMatching.m by using msimple matlab toolbox, while it is not so good to do visualization,
 there is a better visualization UI: http://makinacorpus.github.io/Leaflet.FileLayer/, but I haven't integrated this part to my project, this is the work to be done in the future.
3.compute the velocity for road network, just run computeVelocity4Network.m, note: it will take a long time for finishing this part.
4.compute the velocity for high way road netrk, just run computeVelocity4HighWayNetwork.m, note: it will take a long time for finishing this part.
5.read digital map, just run readOSM.m

About data file:
1.Traces_0418 contains all the GPS sampling traces. This data file a little large, so it take a long time to compute the map-matching process for road network and velocity for each road in every time period.
2.digital map, stored in sanfran_abstract.mat
3.As high way is more important, I store high way ids in HighWayIDs.mat

Results:
1.A test example for map-matching: abboip_0.png (run mainMapMatching.m)
2.wayIDCell_30.mat stores the velocity computation results for processing 30 sub-directories in traces_0418.
