function etaVsT(myStruct,pas,rheoUnits)
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


rheometerStr = "rheometer ";
mpasStr = '';
if pas == 0
    mpasStr = 'm';
end
if rheoUnits == 2
    rheometerStr = '';
elseif rheoUnits == 0
    rheometerStr = '';
end

figure;
plot(getTime(myStruct),getViscosity(myStruct,pas,rheoUnits));
ylabel(strcat( '\eta (',rheometerStr,mpasStr,'Pa s',')' ));
xlabel('t (s)');
title(myStruct.name);
ax1 = gca;
ax1.YScale = 'log';
end