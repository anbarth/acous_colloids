function plotRateCessation(exp)

hold on;
ax1 = gca;
ax1.YScale = 'log';

stress = getStress(exp);
t = getTime(exp);
meanStress = mean(stress(t<30));
plot(t,stress/meanStress,'LineWidth',1);

end