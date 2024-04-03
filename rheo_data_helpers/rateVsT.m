function rateVsT(myStruct,rheoUnits)
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
%hold on;
t = getTime(myStruct);
rate = getRate(myStruct,rheoUnits);



plot(t,rate,'LineWidth',1.5);

ylabel(strcat( 'Rate (',rheometerStr,'1/s',')' ));
xlabel('Time, {\it t} (s)');
title(myStruct.name);
ax1 = gca;
ax1.YScale = 'log';
end