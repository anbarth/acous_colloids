% returns value in Pa s
function dethickenedEta = getDethickenedViscosity(rheoData,tStart,tEnd,showPlot)

eta = getViscosity(rheoData,1,0);
t = getTime(rheoData);

startIndex = find(t>=tStart,1,'first');
endIndex = find(t<=tEnd,1,'last');

myEta = eta(startIndex:endIndex);
myT = t(startIndex:endIndex);

acousticWindowIndexes = findchangepts(myEta,MaxNumChanges=2);
acousStartIndex = acousticWindowIndexes(1);
acousEndIndex = acousticWindowIndexes(2)-1;

dethickenedEta = mean(myEta(acousStartIndex:acousEndIndex));


if showPlot
    % plot eta vs t
    etaVsT(rheoData,1,0);
    hold on;

    % zoom in on acoustic perturbation
    xlim([tStart-3 tEnd]);
    etaRange = max(myEta)-min(myEta);
    ylim([min(myEta)-etaRange/4 max(myEta)+etaRange/4]);

    % show change points
    scatter(myT(acousStartIndex),myEta(acousStartIndex),30,'r');
    scatter(myT(acousEndIndex),myEta(acousEndIndex),30,'r');

    % show dethickened viscosity
    yline(dethickenedEta);
end

%dethickenedEta = getDethickenedViscosity(getViscosity(rheoData),getTime(rheoData),tStart,tEnd);

end