load("optimized_params_02_11.mat");
y_optimal = y_fminsearch;

get_confints_02_22;

volt_list = [0,5,10,20,40,60,80];

CSS=19;


p = polyfit(volt_list,sigmastar*CSS,2);
V = linspace(0,80);


figure; hold on;

for jj=1:7
    voltage = volt_list(jj);
    myColor = cmap(round(1+255*voltage/80),:);
    errorbar(voltage,sigmastar(jj)*CSS,sigmastar_err(jj)*CSS,'o','LineWidth',1,'Color',myColor,'MarkerFaceColor',myColor);
end
plot(V,p(1)*V.^2+p(2)*V+p(3),'k-','LineWidth',1);

xlabel('Acoustic \it{V} (V)')
ylabel('Characteristic stress \sigma^* (Pa)')
prettyPlot;


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
sigmaFake = CSS*logspace(log10(min(sigmastar)/100),log10(max(sigmastar)*100));
%for jj=1
for jj=1:length(volt_list)
    voltage = volt_list(jj);
    myColor = cmap(round(1+255*voltage/80),:);
    plot(sigmaFake,exp(-CSS*sigmastar(jj)./sigmaFake),'-','Color',myColor,'LineWidth',2)
end
prettyPlot;
xlim([0.1 1000])
