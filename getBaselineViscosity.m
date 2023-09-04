function baselineEta = getBaselineViscosity(eta,t,tStart,tEnd)

figure; hold on;
plot(t,eta);

startIndex = find(t>=tStart,1,'first');
endIndex = find(t<=tEnd,1,'last');

myEta = eta(startIndex:endIndex);

baselineEta = mean(myEta);
yline(baselineEta);


end