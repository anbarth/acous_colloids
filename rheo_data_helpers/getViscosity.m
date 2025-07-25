function eta = getViscosity(rheoData,pas,CSV)
% pas: 1 for pa s, 0 for mpa s (default: pa s)
% rheoUnits: correction factor

if nargin < 3
    CSV = 0;
end
if nargin < 2
    pas = 1;
end


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
if CSV ~= 0
    unitFactor = unitFactor*CSV;
end

eta = rheoData.data(:,etaColumn)*unitFactor;
%disp(unitFactor)

end