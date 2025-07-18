function etaVsT(myStruct,rheoUnits,pas,myColorNum)
% pas: 1 for pa s, 0 for mpa s (default: pa s)
% rheoUnits: correction factor


if nargin < 2
    rheoUnits = 0;
end
if nargin < 3
    pas = 1;
end



mpasStr = '';
if pas == 0
    mpasStr = 'm';
end


%figure;
%hold on;
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
ylabel(strcat( 'Viscosity, \eta (',mpasStr,'Pa.s',')' ));
xlabel('Time, {\it t} (s)');
title(myStruct.name);
ax1 = gca;
ax1.YScale = 'log';
end