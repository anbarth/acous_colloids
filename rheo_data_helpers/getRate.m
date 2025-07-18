function rate = getRate(rheoData,CSR)
% rheoUnits: correction factor

if nargin < 2
    CSR = 0;
end

rateColumn = find(strcmp(rheoData.headers,'Shear Rate'));

if strcmp('[1/s]',rheoData.units{rateColumn})
    unitFactor = 1;
else
    unitFactor = 0;
    disp("check rate units?")
end


if CSR ~= 0
    unitFactor = unitFactor*CSR;
end

rate = rheoData.data(:,rateColumn)*unitFactor;

end