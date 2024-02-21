function plotCessation(myStruct)
% rheoUnits: 0 for rheometer units ARE real units (default), 1 for show me
% plain uncorrected rheometer units, 2 for rheometer units are incorrect
% and please correct them
rheoUnits = 2; % doesn't matter since we normalize the stress anyway
myStress = getStress(myStruct,rheoUnits);

plot(getTime(myStruct)-25,myStress/myStress(1),'LineWidth',1);


ylabel(strcat( '\sigma/\sigma_{app}' ));
xlabel('t (s)');
title(myStruct.name);
ax1 = gca;
ax1.YScale = 'log';
end