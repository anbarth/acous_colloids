meeraX = [];
meeraY = [];

fig = openfig("ScalingCornstarchSilica.fig");
axObjs = fig.Children;
myScatters = axObjs(2).Children;
for ii = 2:length(myScatters)
    thisScatter = myScatters(ii);
    newX = thisScatter.XData;
    newY = thisScatter.YData;
    meeraX(end+1:end+length(newX)) = newX;
    meeraY(end+1:end+length(newY)) = newY;
end


figure;
hold on;
ax1 = gca;
ax1.XScale = 'log';
ax1.YScale = 'log';
xlim(ax1,[10^(-5) 15]);
scatter(ax1,meeraX,meeraY);