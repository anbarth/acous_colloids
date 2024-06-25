function plotStressCessation(exp)

hold on;
%ax1 = gca;
%ax1.YScale = 'log';

rate = getRate(exp);
t = getTime(exp);
meanRate = mean(rate(t<30));
plot(t,rate/meanRate,'LineWidth',1);

end