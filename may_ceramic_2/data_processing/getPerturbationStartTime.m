function [tStartAcous,eta,t] = getPerturbationStartTime(rheoData,myT)

if myT == 0
    % t=0 means no dethickening noticable
    return
end


% basically copied from getDethickenedViscosity(rheoData,myT,myT+10,showPlots);

% get eta, t data in the specified window
eta = getViscosity(rheoData,1,0);
t = getTime(rheoData);

tStart=myT;
tEnd=myT+10;
startIndex = find(t>=tStart,1,'first');
endIndex = find(t<=tEnd,1,'last');

myEta = eta(startIndex:endIndex);
myTime = t(startIndex:endIndex);

% find the window where the viscosity changes (ie where acoustics is on)
acousticWindowIndexes = findchangepts(myEta,MaxNumChanges=2);


if length(acousticWindowIndexes) == 2
    acousStartIndex = acousticWindowIndexes(1);
    %acousEndIndex = acousticWindowIndexes(2)-1;
    %dethickenedEta = mean(myEta(acousStartIndex:acousEndIndex));
    %delta_eta = std(myEta(acousStartIndex:acousEndIndex));
    tStartAcous = myTime(acousStartIndex);
else
    % failed to find 2 change points
    % ive noticed this error occurs a lot for sections where 
    % dethickening didn't rly happen, so this is my workaround
    
    tStartAcous = -1;
end

end