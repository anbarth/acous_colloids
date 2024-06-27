function plotStressCessation(exp,tStart)

if nargin < 2
    tStart=30;
end

hold on;
%ax1 = gca;
%ax1.YScale = 'log';
xlabel('t (s)')
ylabel('rate/mean rate')

rate = getRate(exp);
t = getTime(exp);
%meanRate = mean(rate(t<tStart));
meanRate = mean(rate(t<tStart & t>tStart-5));
plot(t-tStart,rate/meanRate,'LineWidth',1);
xlim([-10 30])

end