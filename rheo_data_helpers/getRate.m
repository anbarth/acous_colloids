function rate = getRate(rheoData,rheoUnits)
% rheoUnits: 0 for rheometer units ARE real units (default), 1 for show me
% plain uncorrected rheometer units, 2 for rheometer units are incorrect
% and please correct them

if nargin < 2
    rheoUnits = 0;
end

CSS = 19;
CSV = 50;
CSR = CSS/CSV; 

rateColumn = find(strcmp(rheoData.headers,'Shear Rate'));

if strcmp('[1/s]',rheoData.units{rateColumn})
    unitFactor = 1;
else
    unitFactor = 0;
    disp("check rate units?")
end


if rheoUnits == 2
    unitFactor = unitFactor*CSR;
end

rate = rheoData.data(:,rateColumn)*unitFactor;

end