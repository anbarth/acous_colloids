function etaVsTimeWithTimeMarkers(myStruct,rheoUnits,pas)
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


figure;
hold on;
t = getTime(myStruct);
eta = getViscosity(myStruct,pas,rheoUnits);
t = t(eta>0);
eta = eta(eta>0);


plot(t,eta,'LineWidth',1);

ylabel(strcat( 'Viscosity, \eta (',mpasStr,'Pa.s',')' ));
xlabel('Time, {\it t} (s)');
title(myStruct.name);
ax1 = gca;
ax1.YScale = 'log';

t_markers = myStruct.t_markers;
t_indices = ismember(t,t_markers);
plot(t(t_indices),eta(t_indices),'ro')

end