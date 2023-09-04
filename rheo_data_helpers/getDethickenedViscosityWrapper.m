function dethickenedEta = getDethickenedViscosityWrapper(rheoData,tStart,tEnd)

dethickenedEta = getDethickenedViscosity(getViscosity(rheoData),getTime(rheoData),tStart,tEnd);

end