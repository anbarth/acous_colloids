function sigmaVsT(myStruct,rheoUnits,myColorNum)
% rheoUnits: 0 for rheometer units ARE real units (default), 1 for show me
% plain uncorrected rheometer units, 2 for rheometer units are incorrect
% and please correct them


if nargin < 2
    rheoUnits = 0;
end


rheometerStr = "rheometer ";
if rheoUnits == 2
    rheometerStr = '';
elseif rheoUnits == 0
    rheometerStr = '';
end

%figure;
if nargin < 3
    plot(getTime(myStruct),getStress(myStruct,rheoUnits),'LineWidth',1);
else
    cmap = jet(256);
    myColor = cmap(round(1+255*myColorNum/80),:);
    plot(getTime(myStruct),getStress(myStruct,rheoUnits),'LineWidth',1,'Color',myColor);
end
ylabel(strcat( '\sigma (',rheometerStr,'Pa',')' ));
xlabel('t (s)');
title(myStruct.name);
ax1 = gca;
ax1.YScale = 'log';
end