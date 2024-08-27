function plotReversal(exp,tStart,rescaling,myColor)

if nargin < 2
    tStart=30;
end
if nargin < 3
    rescaling = 1;
end

hold on;
ax1 = gca;
ax1.YScale = 'log';
xlabel('t (s)')
ylabel('\eta(\phi_0-\phi)^2 (Pa s)')

eta = getViscosity(exp);
t = getTime(exp);
if nargin < 4
    plot(t-tStart,eta*rescaling,'LineWidth',1);
else
    plot(t-tStart,eta*rescaling,'LineWidth',1,'Color',myColor);
end
xlim([-10 30])

end