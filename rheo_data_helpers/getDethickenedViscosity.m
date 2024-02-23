% returns value in Pa s
function dethickenedEta = getDethickenedViscosity(rheoData,tStart,tEnd,showPlot)

% get eta, t data in the specified window
eta = getViscosity(rheoData,1,0);
t = getTime(rheoData);

startIndex = find(t>=tStart,1,'first');
endIndex = find(t<=tEnd,1,'last');

myEta = eta(startIndex:endIndex);
myT = t(startIndex:endIndex);

% find the window where the viscosity changes (ie where acoustics is on)
acousticWindowIndexes = findchangepts(myEta,MaxNumChanges=2);


if length(acousticWindowIndexes) == 2
    acousStartIndex = acousticWindowIndexes(1);
    acousEndIndex = acousticWindowIndexes(2);
    dethickenedEta = mean(myEta(acousStartIndex:acousEndIndex));
else
    % failed to find 2 change points
    % ive noticed this error occurs a lot for sections where 
    % dethickening didn't rly happen, so this is my workaround
    
    % average over the viscosity before first application of acoustics
    tAcous = min(rheoData.acous(:,4));
    if tAcous == 0
        % no acoustics in this experiment? average over 60s
        tAcous = 60;
    end
    
    dethickenedEta = getBaselineViscosity(rheoData,5,tAcous,false);
end


if showPlot
    % plot eta vs t
    etaVsT(rheoData,1,0);
    hold on;

    % zoom in on acoustic perturbation
    xlim([tStart-3 tEnd]);
    etaRange = max(myEta)-min(myEta);
    ylim([min(myEta)-etaRange/4 max(myEta)+etaRange/4]);

    % show change points
    scatter(myT(acousticWindowIndexes),myEta(acousticWindowIndexes),30,'r');
    %scatter(myT(acousStartIndex),myEta(acousStartIndex),30,'r');
    %scatter(myT(acousEndIndex),myEta(acousEndIndex),30,'r');
    
    % show dethickened viscosity
    yline(dethickenedEta);
end

%dethickenedEta = getDethickenedViscosity(getViscosity(rheoData),getTime(rheoData),tStart,tEnd);

end