function height = metamaterialEnvelopeHeight(rheoData,tStart,tEnd,showPlot)

% get eta, t data in the specified window
eta = getViscosity(rheoData,1,0);
t = getTime(rheoData);

startIndex = find(t>=tStart,1,'first');
endIndex = find(t<=tEnd,1,'last');

myEta = eta(startIndex:endIndex);

height = max(myEta)-min(myEta);


if showPlot
    % plot eta vs t
    etaVsT(rheoData,1,0);
    hold on;

    % zoom in on acoustic perturbation
    xlim([tStart-2 tEnd+2]);
    etaRange = height;
    ylim([min(myEta)-etaRange/4 max(myEta)+etaRange/4]);
    
    % show envelope
    yline(min(myEta));
    yline(max(myEta));
end

end