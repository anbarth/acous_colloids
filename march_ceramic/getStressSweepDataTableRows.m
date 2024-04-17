function dataTable = getStressSweepDataTableRows(mySweep,myPhi,excludeSigma,fillInHighVolts)

if nargin < 4
   fillInHighVolts = 0; 
end

volts = 0;
if fillInHighVolts
    volts = [0, 5, 10, 20, 40, 60, 80, 100];
end

dataTable = zeros(0,5);

sigma = getStress(mySweep);
eta = getViscosity(mySweep);

stress_list = unique(sigma);
for ii = 1:size(stress_list)
   mySigma = stress_list(ii);
   if any(mySigma==excludeSigma)
       % skip over any sigmas you don't want to
       % grab from the stress sweep
       % (ie bc you already got it from an acous experiment)
        continue
   end
   %%% TODO cut off the first 5-10s? of each stress
   indices = sigma == mySigma;
   myEta = mean(eta(indices));
   myDeltaEta = std(eta(indices));
   for V=volts
        dataTable(end+1,1:5) = [myPhi,mySigma,V,myEta,myDeltaEta];
   end
end

end