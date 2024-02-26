% returns value in Pa s
function [baselineEta,delta_eta] = getBaselineViscosity(rheoData,tStart,tEnd,showPlot)

% get eta, t in specified window
eta = getViscosity(rheoData,1,0);
t = getTime(rheoData);

startIndex = find(t>=tStart,1,'first');
endIndex = find(t<=tEnd,1,'last');

myEta = eta(startIndex:endIndex);

baselineEta = mean(myEta);
delta_eta = std(myEta);

if showPlot
    % plot eta vs t
    etaVsT(rheoData,1,0);
    hold on;

    % show baseline viscosity
    yline(baselineEta);

end

%baselineEta = getBaselineViscosity(getViscosity(rheoData),getTime(rheoData),tStart,tEnd);

end