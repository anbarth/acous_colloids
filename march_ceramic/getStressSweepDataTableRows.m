function dataTable = getStressSweepDataTableRows(mySweep,myPhi,excludeSigma,fillInHighVolts,showPlot)

if nargin < 4
   fillInHighVolts = 0; 
end

if nargin < 5
    showPlot = false;
end

volts = 0;
if fillInHighVolts
    volts = [0, 5, 10, 20, 40, 60, 80, 100];
end

dataTable = zeros(0,5);

sigma = getStress(mySweep);
eta = getViscosity(mySweep);
t = getTime(mySweep);

stress_list = unique(sigma);
for ii = 1:length(stress_list)
   mySigma = stress_list(ii);
   if any(mySigma==excludeSigma)
       % skip over any sigmas you don't want to
       % grab from the stress sweep
       % (ie bc you already got it from an acous experiment)
        continue
   end
   %%% TODO cut off the first 5-10s? of each stress
   indices = sigma == mySigma;
   myEta = eta(indices);
   myT = t(indices);

   % shift myT=0 for the beginning of EACH interval where stress=mySigma is applied
   % assume distinct intervals are spaced by at least 10s
   jumpPoints = [1; 1+find(myT(2:end)-myT(1:end-1) > 10)];
   for jj=1:length(jumpPoints)
        t0_index = jumpPoints(jj);
        myT = [myT(1:t0_index-1);myT(t0_index:end)-myT(t0_index)];
   end
   % now cut off the first 10s of the interval
   myEta = myEta(myT>10);

   myEtaAvg = mean(myEta);
   myDeltaEta = std(myEta);
   for V=volts
        dataTable(end+1,1:5) = [myPhi,mySigma,V,myEtaAvg,myDeltaEta];
   end
end

if showPlot
    etaVsT(mySweep)
    viscosities = unique(dataTable(:,4));
    for ii = 1:length(viscosities)
        yline(viscosities(ii))
    end
end