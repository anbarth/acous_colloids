% returns value in Pa s
function baselineEta = getBaselineViscosity(rheoData,tStart,tEnd,showPlot)

eta = getViscosity(rheoData,1,0);
t = getTime(rheoData);

startIndex = find(t>=tStart,1,'first');
endIndex = find(t<=tEnd,1,'last');

myEta = eta(startIndex:endIndex);

baselineEta = mean(myEta);

if showPlot
    % plot eta vs t
    etaVsT(rheoData,1,0);
    hold on;

    % show baseline viscosity
    yline(baselineEta);

end

%baselineEta = getBaselineViscosity(getViscosity(rheoData),getTime(rheoData),tStart,tEnd);

end