sigma = logspace(-1,4);
x = [1, 10, 0.56, 0.64];
phi = [0.3,0.35,0.4,0.44,0.46,0.48,0.5,0.52,0.54];

figure; hold on;
ax1 = gca;
ax1.XScale = 'log';
ax1.YScale = 'log';

cmap = plasma(256);
colormap(ax1,cmap);

for ii=1:length(phi)
    eta=x(1)*( x(4)*(1-exp(-x(2)./sigma)) + x(3)*exp(-x(2)./sigma) - phi(ii) ).^(-2);
    myColor = cmap(round(1+255*(phi(ii)-0.3)/(0.55-0.3)),:);
    plot(sigma, eta,'Color',myColor,'LineWidth',2);
end

c1=colorbar;
caxis(ax1,[.3 .54]);
c1.Ticks = phi;

