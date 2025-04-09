cmap= plasma(256);
myColor = @(voltage) cmap(round(1+255*voltage/80),:);
volt_list = [0 5 10 20 40 60 80];

dataTable = may_ceramic_09_17;
allData = {phi44_05_29,phi46_06_19,phi48_05_31,phi52_05_29,phi54_06_01,phi56_05_31,phi59_05_30,phi61_06_20};


phi_list = unique(dataTable(:,1));
phi = phi_list(13);
sigma=50;
CSV = (50/19)^3;

figure; hold on; ax1=gca; ax1.YScale='log';
for jj=2:length(volt_list)
    V = volt_list(jj);
    [eta,t,tStart] = findThisPerturbationDisplayInfo(phi,sigma,V,allData);
    plot(t-tStart,eta*CSV,'-','Color',myColor(V),'LineWidth',2);
end
xlim([-5 10])
ylim([400 15000])


xlabel('{\itt}-{\itt}_{acous} (s)')
ylabel('Viscosity \eta (Pa s)')
prettyPlot;


colormap(cmap);
c1=colorbar;
clim([0 80]);
c1.Ticks = [0,5,10,20,40,60,80];

myfig = gcf;
myfig.Position=[627,403,465,323];