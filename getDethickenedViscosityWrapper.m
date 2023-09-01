function dethickenedEta = getDethickenedViscosityWrapper(rheoData,tStart,tEnd)

timeColumn = find(strcmp(rheoData.headers,'Time'));
etaColumn = find(strcmp(rheoData.headers,'Viscosity'));

dethickenedEta = getDethickenedViscosity(rheoData.data(:,etaColumn),rheoData.data(:,timeColumn),tStart,tEnd);

end