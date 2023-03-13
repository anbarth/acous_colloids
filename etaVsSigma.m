function etaVsSigma(data)
CSS = (50/19)^3;
CSR = 19/50;
CSV = CSS/CSR;
figure;
t = tiledlayout(1,1);
ax1 = axes(t);
plot(ax1,data(:,3)*CSS,data(:,5)/1000*CSV,'-o');
ylabel('\eta (Pa s)');
xlabel('\sigma (Pa)');
ax1.XScale = 'log';
ax1.YScale = 'log';
ax1.Box = 'off'; % prevents box edges from covering axes

%ax2 = axes(t);
%plot(ax2,data(:,3),data(:,5)/1000*CSV,'-o');
%ax2.XAxisLocation = 'top';
%ax2.Color = 'none';
%ax2.Box = 'off'; % prevents box edges from covering axes
end