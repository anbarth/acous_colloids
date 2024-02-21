function sigma = getStress(rheoData,rheoUnits)
% rheoUnits: 0 for rheometer units ARE real units (default), 1 for show me
% plain uncorrected rheometer units, 2 for rheometer units are incorrect
% and please correct them

if nargin < 2
    rheoUnits = 0;
end

CSS = 19;
CSV = 50;

sigmaColumn = find(strcmp(rheoData.headers,'Shear Stress'));

if strcmp('[Pa]',rheoData.units{sigmaColumn})
    unitFactor = 1;
else
    unitFactor = 0;
    disp("check stress units?")
end


if rheoUnits == 2
    unitFactor = unitFactor*CSS;
end

sigma = rheoData.data(:,sigmaColumn)*unitFactor;

end