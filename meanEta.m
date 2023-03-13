function myMeanEta = meanEta(myStruct,tstart,tfinal)

CSS = (50/19)^3;
CSR = 19/50;
CSV = CSS/CSR;

if strcmp('[mPa·s]',myStruct.units{5})
    unitFactor = 1/1000;
elseif strcmp('[Pa·s]',myStruct.units{5})
    unitFactor = 1;
else
    unitFactor = 0;
    disp("check viscosity units?")
end

time = myStruct.data(:,2);
eta = myStruct.data(:,5)*unitFactor*CSV;
myRange = time >= tstart & time <= tfinal;
myMeanEta = mean(eta(myRange));

end