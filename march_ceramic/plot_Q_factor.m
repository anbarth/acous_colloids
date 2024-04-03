fig_Q = figure;
ax_Q = axes('Parent', fig_Q,'XScale','log','YScale','log');
ax_Q.XLabel.String = "sigma";
ax_Q.YLabel.String = "Q";
%colormap(ax_Q,cmap);
hold(ax_Q,'on');
cmap = turbo;
colormap(ax_Q,cmap);

phis = [0.44 0.48 0.52 0.56, 0.59];
minPhi=0.44;
maxPhi=0.6;
for ii=1:length(phis)
    phi = phis(ii);
    Q_table = Q_tab_k05(phi);
    plot(Q_table(:,1),Q_table(:,2),'-o','Color',cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:))
end

ylim([0.01 100])
sigma = logspace(-2,2);
plot(sigma, sigma/10,'Color',cmap(round(1+255*(0.59-minPhi)/(maxPhi-minPhi)),:));
plot(sigma, sigma/3,'Color',cmap(round(1+255*(0.56-minPhi)/(maxPhi-minPhi)),:));
plot(sigma, sigma/1,'Color',cmap(round(1+255*(0.52-minPhi)/(maxPhi-minPhi)),:));
plot(sigma, sigma/0.5,'Color',cmap(round(1+255*(0.48-minPhi)/(maxPhi-minPhi)),:));
plot(sigma, sigma/0.2,'Color',cmap(round(1+255*(0.44-minPhi)/(maxPhi-minPhi)),:));
%plot(sigma, exp(sigma/3))
%plot(sigma, exp(1/20*(log(sigma/0.03)).^2))

legend('0.44','0.48','0.52','0.56','0.59')

figure; plot(phis,[0.2,0.5,1,3,10],'--o');