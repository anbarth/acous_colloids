function dataTable = getStressSweepDataTableRows(mySweep,myPhi,excludeSigma)

%mySweep = phi40_02_20.stress_sweep_low_init;
%myPhi = 0.40;

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
   indices = sigma == mySigma;
   myEta = mean(eta(indices));
   myDeltaEta = std(eta(indices));
   dataTable(end+1,1:5) = [myPhi,mySigma,0,myEta,myDeltaEta];
end

end