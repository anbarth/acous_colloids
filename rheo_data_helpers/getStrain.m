function strain = getStrain(rheoData,rheoUnits)
% rheoUnits: 0 for rheometer units ARE real units (default), 1 for show me
% plain uncorrected rheometer units, 2 for rheometer units are incorrect
% and please correct them

if nargin < 2
    rheoUnits = 0;
end

CSS = 19;
CSV = 50;
CSR = CSS/CSV; % this is also the strain correction factor

strainColumn = find(strcmp(rheoData.headers,'Shear Strain'));

if strcmp('[%]',rheoData.units{strainColumn})
    unitFactor = 1/100;
else
    unitFactor = 0;
    disp("check stress units?")
end


if rheoUnits == 2
    unitFactor = unitFactor*CSR;
end

strain = rheoData.data(:,strainColumn)*unitFactor;

end