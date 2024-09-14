% returns value in Pa s
function [dethickenedEta,delta_eta,baseline_eta,sloppy] = getDethickenedViscosity_excludeSloppy(rheoData,tStart,tEnd,showPlot)

sloppy = false;

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
    acousStartIndex = acousticWindowIndexes(1)+2;
    acousEndIndex = acousticWindowIndexes(2)-2;

    acousEta = myEta(acousStartIndex:acousEndIndex);
    acousT = myT(acousStartIndex:acousEndIndex);

    dethickenedEta = mean(acousEta);
    delta_eta = std(acousEta);

    
    myLinearFit = polyfit(acousT,acousEta,1);
    etaChangeFromSlope = abs(myLinearFit(1)*5); % change in eta due to slope over 5 sec
    referenceIndex = max(1,acousStartIndex-5);
    etaChangeFromAcous = myEta(referenceIndex) - dethickenedEta;
    baseline_eta =  myEta(referenceIndex);
    %disp([etaChangeFromAcous etaChangeFromSlope])
    if etaChangeFromSlope > 0.2*etaChangeFromAcous
    %if etaChangeFromAcous > 0.1*dethickenedEta
        %disp("sloppy!!")
        sloppy=true;
    end


    
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
    
    %[dethickenedEta,delta_eta] = getBaselineViscosity(rheoData,5,tAcous,false);
    %baseline_eta = dethickenedEta;
    dethickenedEta = -1;
    delta_eta = -1;
    baseline_eta = -1;
end


if showPlot
    % plot eta vs t
    etaVsT(rheoData,1,0);
    hold on;

    % zoom in on acoustic perturbation
    xlim([tStart-3 tEnd]);
    etaRange = max(myEta)-min(myEta);
    ylim([min(myEta)-etaRange/4 max(myEta)+etaRange/4]);
    
    if length(acousticWindowIndexes) == 2
        % show change points
        scatter(myT([acousStartIndex,acousEndIndex]),myEta([acousStartIndex,acousEndIndex]),30,'r');
        
        % show dethickened viscosity
        yline(baseline_eta)
        yline(dethickenedEta);
    
        % show linear fit
        myColor = 'k';
        if sloppy
            myColor = 'r';
        end
        plot(linspace(tStart-3,tEnd),myLinearFit(1)*linspace(tStart-3,tEnd)+myLinearFit(2),'--','Color',myColor);
    end
end

%dethickenedEta = getDethickenedViscosity(getViscosity(rheoData),getTime(rheoData),tStart,tEnd);

end