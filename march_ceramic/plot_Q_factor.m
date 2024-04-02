fig_Q = figure;
ax_Q = axes('Parent', fig_Q,'XScale','log','YScale','log');
ax_Q.XLabel.String = "sigma";
ax_Q.YLabel.String = "Q";
%colormap(ax_Q,cmap);
hold(ax_Q,'on');

phis = [0.44 0.48 0.52 0.56];
for ii=1:length(phis)
    phi = phis(ii);
    Q_table = Q_tab(phi);
    plot(Q_table(:,1),Q_table(:,2),'-o')
end

legend('0.44','0.48','0.52','0.56')