mySweep = phi40_02_20.stress_sweep_low_init;
myPhi = 0.40;

sigma = getStress(mySweep);
eta = getViscosity(mySweep,1);

stress_list = unique(sigma);
for ii = 1:size(stress_list)
   mySigma = stress_list(ii);
   indices = sigma == mySigma;
   myEta = mean(eta(indices));
   dataTable(end+1,1:4) = [myPhi,mySigma,0,myEta];
   %disp([myPhi,mySigma,0,myEta])
end