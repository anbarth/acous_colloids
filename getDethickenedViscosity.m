function dethickenedEta = getDethickenedViscosity(eta,t,tStart,tEnd)

figure; hold on;
plot(t,eta);

startIndex = find(t>=tStart,1,'first');
endIndex = find(t<=tEnd,1,'last');

myEta = eta(startIndex:endIndex);
myT = t(startIndex:endIndex);

etaRange = max(myEta)-min(myEta);
xlim([tStart tEnd]);
ylim([min(myEta)-etaRange/4 max(myEta)+etaRange/4]);

acousticWindowIndexes = findchangepts(myEta,MaxNumChanges=2);
acousStartIndex = acousticWindowIndexes(1)+1;
acousEndIndex = acousticWindowIndexes(2)-1;

scatter(myT(acousStartIndex),myEta(acousStartIndex),30,'r');
scatter(myT(acousEndIndex),myEta(acousEndIndex),30,'r');

dethickenedEta = mean(myEta(acousStartIndex:acousEndIndex));
yline(dethickenedEta);


end