function baselineEta = getBaselineViscosityWrapper(rheoData,tStart,tEnd)

baselineEta = getBaselineViscosity(getViscosity(rheoData),getTime(rheoData),tStart,tEnd);

end