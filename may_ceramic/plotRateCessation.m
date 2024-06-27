function plotRateCessation(exp,tStart)

if nargin < 2
    tStart=30;
end

hold on;
ax1 = gca;
ax1.YScale = 'log';
xlabel('t (s)')
ylabel('stress/mean stress')

stress = getStress(exp);
t = getTime(exp);
meanStress = mean(stress(t<tStart & t>tStart-5));
plot(t-tStart,stress/meanStress,'LineWidth',1);
xlim([-10 30])

end