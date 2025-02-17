function plot_sigmastar(y_optimal)

[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsHandpickedAll(y_optimal,13);

volt_list = [0,5,10,20,40,60,80];

%figure; hold on;


p = polyfit(volt_list,sigmastar,2);
V = linspace(0,80);
%plot(V,p(1)*V.^2+p(2)*V+p(3),'--','LineWidth',1);

plot(volt_list,sigmastar,'o-','LineWidth',2);

xlabel('V')
ylabel('\sigma^* (Pa)')

%sigmastarFit = (p(1)*volt_list.^2+p(2)*volt_list+p(3));

return
figure; hold on;
ax1=gca;
ax1.XScale='log';
cmap = plasma(256);
colormap(cmap);

cbar = colorbar;
clim([0 80]);
cbar.Ticks = [0,5,10,20,40,60,80];

ylabel('Fraction of frictional contacts{\it f}')
xlabel('Shear stress \sigma (Pa)')
sigmaFake = logspace(log10(min(sigmastarFit)/100),log10(max(sigmastarFit)*100));
%for jj=1
for jj=1:length(volt_list)
    voltage = volt_list(jj);
    myColor = cmap(round(1+255*voltage/80),:);
   % plot(sigmaFake,exp(-sigmastarFit(jj)./sigmaFake),'-','Color',myColor,'LineWidth',2)
   plot(sigmaFake,sigmaFake./(sigmastarFit(jj)+sigmaFake),'-','Color',myColor,'LineWidth',2)
end

end