function [avg,height] = metamaterialEnvelope(rheoData,tStart,tEnd,showPlot,phi)
% include phi in input iff you want to recale to eta(phi0-phi)^2

if nargin<5
    phi=0;
end

% get eta, t data in the specified window
eta = getViscosity(rheoData,1,0);
t = getTime(rheoData);

startIndex = find(t>=tStart,1,'first');
endIndex = find(t<=tEnd,1,'last');

myEta = eta(startIndex:endIndex);
height = max(myEta)-min(myEta);
avg = mean(myEta);


if showPlot
    
    
    % plot eta vs t
    if phi==0
        etaVsT(rheoData,1,0);
        etaRange = height;
        avgPlot = avg;
    else
        rescaledEtaVsT(rheoData,(0.68-phi)^2);
        myEta = myEta*(0.68-phi)^2;
        avgPlot = avg*(0.68-phi)^2;
        etaRange = height*(0.68-phi)^2;
    end
    hold on;

    % zoom in on acoustic perturbation
    xlim([tStart-2 tEnd+2]);
    ylim([min(myEta)-etaRange/4 max(myEta)+etaRange/4]);
    
    % show envelope
    yline(min(myEta));
    yline(max(myEta));
    yline(avgPlot);
end

end