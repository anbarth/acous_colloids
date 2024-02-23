function etaVsT(myStruct,pas,rheoUnits,myColorNum)
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
hold on;
t = getTime(myStruct);
eta = getViscosity(myStruct,pas,rheoUnits);
t = t(eta>0);
eta = eta(eta>0);

if nargin < 4
    plot(t,eta,'LineWidth',1.5);
else
    cmap = jet(256);
    myColor = cmap(round(1+255*myColorNum/80),:);
    plot(t,eta,'LineWidth',1.5,'Color',myColor);
end
ylabel(strcat( 'Viscosity, \eta (',rheometerStr,mpasStr,'Pa.s',')' ));
xlabel('Time, {\it t} (s)');
title(myStruct.name);
ax1 = gca;
ax1.YScale = 'log';
end