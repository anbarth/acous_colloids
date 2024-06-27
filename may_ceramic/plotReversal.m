function plotReversal(exp,tStart,rescaling)

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
plot(t-tStart,eta*rescaling,'LineWidth',1);
xlim([-10 30])

end