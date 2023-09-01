function etaVsT(myStruct,pas,rheoUnits)
% pas: 1 for pa s, 0 for mpa s (default: pa s)
% rheoUnits: 0 for real units, 1 for rheometer units (default: real units)


if nargin < 3
    rheoUnits = 0;
end
if nargin < 2
    pas = 1;
end

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

rheometerStr = "rheometer ";
mpasStr = '';
if pas == 0
    unitFactor = unitFactor*1000;
    mpasStr = 'm';
end
if rheoUnits == 0
    unitFactor = unitFactor*CSV;
    rheometerStr = '';
end

figure;
% if you want to plot rheometer units, take out CSV
plot(myStruct.data(:,2),myStruct.data(:,5)*unitFactor);
%ylabel('\eta (rheometer mPa s)');
%ylabel('\eta (Pa s)');
ylabel(strcat( '\eta (',rheometerStr,mpasStr,'Pa s',')' ));
xlabel('t (s)');
title(myStruct.name);
ax1 = gca;
ax1.YScale = 'log';
end