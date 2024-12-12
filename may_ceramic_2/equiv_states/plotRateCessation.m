function plotRateCessation(exp,tStart,myColor)

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
if nargin < 3
    plot(t-tStart,stress/meanStress,'LineWidth',1);
else
    plot(t-tStart,stress/meanStress,'LineWidth',1,'Color',myColor);
end
xlim([-10 30])

end