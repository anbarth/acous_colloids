function eta_avg = averageEtaInterval(rheoStruct,tStart,tEnd)

t = getTime(rheoStruct);
eta = getViscosity(rheoStruct);

interval_pts = t>=tStart & t<=tEnd;
eta_avg = mean(eta(interval_pts));

end