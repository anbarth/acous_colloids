%collapse_params;
%load("y_optimal_crossover_post_fudge_1percent_06_27.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13); fxnType = 2;
load("y_09_04.mat"); y_optimal = y_handpicked_xcShifted_09_04; [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13);

volt_list = [0,5,10,20,40,60,80];

figure; hold on;


p = polyfit(volt_list,sigmastar*19,2);
V = linspace(0,80);
plot(V,p(1)*V.^2+p(2)*V+p(3),'-','LineWidth',1);

plot(volt_list,sigmastar*19,'ok','LineWidth',2);

xlabel('V')
ylabel('\sigma^* (Pa)')

sigmastarFit = (p(1)*volt_list.^2+p(2)*volt_list+p(3))/19;

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
for jj=1:length(volt_list)
    voltage = volt_list(jj);
    myColor = cmap(round(1+255*voltage/80),:);
    plot(sigmaFake,exp(-sigmastarFit(jj)./sigmaFake),'-','Color',myColor,'LineWidth',2)
end