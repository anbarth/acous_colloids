function dataTable = getAllDataTableRows(myVolumeFractionStruct,mySweep,myPhi,showPlots)

% here's how you fill in the rows
% 1. extract all the acoustic dethickened viscosities
% (including 0v data from those same experiments)
acous_rows = getAcousDataTableRows(myVolumeFractionStruct, showPlots);
% 2. note the stresses included in (1)
acous_sigma = unique(acous_rows(:,2));
% 3. fill in any gaps with stresses from the low stress sweep
low_rows = getStressSweepDataTableRows(mySweep,myPhi,acous_sigma,1);

dataTable = [low_rows; acous_rows];

% 4. fill in phi with myPhi (low_rows will already have this phi, but
% acous_rows might have smth different)
dataTable(:,1) = myPhi*ones(size(dataTable(:,1)));

end