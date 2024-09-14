function eta = getViscosity(rheoData,pas,rheoUnits)
% pas: 1 for pa s, 0 for mpa s (default: pa s)
% rheoUnits: 0 for rheometer units ARE real units (default), 1 for show me
% plain uncorrected rheometer units, 2 for rheometer units are incorrect
% and please correct them

if nargin < 3
    rheoUnits = 0;
end
if nargin < 2
    pas = 1;
end

CSS = 19;
CSV = 25;
CSR = CSS/CSV;

etaColumn = find(strcmp(rheoData.headers,'Viscosity'));

if strcmp('[mPa·s]',rheoData.units{etaColumn})
    unitFactor = 1/1000;
elseif strcmp('[Pa·s]',rheoData.units{etaColumn})
    unitFactor = 1;
else
    unitFactor = 0;
    disp("check viscosity units?")
end

if pas == 0
    unitFactor = unitFactor*1000;
end
if rheoUnits == 2
    unitFactor = unitFactor*CSV;
end

eta = rheoData.data(:,etaColumn)*unitFactor;
%disp(unitFactor)

end