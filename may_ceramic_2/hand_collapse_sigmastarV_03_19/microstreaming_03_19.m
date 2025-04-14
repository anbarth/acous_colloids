%optimize_sigmastarV_03_19;

% start with parameters where sigma*(V) and D(phi) are picked pt-by-pt
y_pointwise = y_fmincon; myModelHandle = @modelHandpickedSigmastarV;
confInts = get_conf_ints(may_ceramic_09_17,y_pointwise,myModelHandle);


sigmastar = y_pointwise(6:12);
sigmastar_ci = confInts(6:12);
volt_list = [0 5 10 20 40 60 80];
s = sigmastar~=0;
sigmastar = sigmastar(s);
my_volt_list = volt_list(s);

quadfit = fittype("a*x^2+b*x+c");
%sigmastarFit = fit(my_volt_list',sigmastar',quadfit,'StartPoint',[0.0001, 0.0005, 0.07]);
sigmastarFit = fit(my_volt_list',sigmastar',quadfit,'StartPoint',[0.0001, 0.0005, 0.07],'Weights',1./sigmastar_ci);


CSS=(50/19)^3;
sigmastar_acous = CSS*(sigmastar-sigmastar(1));

%return
%%
figure; hold on; 
xlabel('Acoustic voltage {\itV} (V)'); ylabel('\sigma^*_a (Pa)');

% quadratic interpolation
V = linspace(0,80);
plot(V,CSS*polyval([sigmastarFit.a sigmastarFit.b sigmastarFit.c],V)-CSS*sigmastar(1),'r-');

plot(V,acoustic_energy_density(V),'k-');

% points with err bars
cmap = plasma(256);
myColor = @(V) cmap(round(1+255*V/80),:);
for jj=1:length(my_volt_list)
    colorV = myColor(my_volt_list(jj));
    plot(my_volt_list(jj),sigmastar_acous(jj),'p','Color',colorV,'MarkerFaceColor',colorV,'MarkerSize',5,'LineWidth',1.5);
    
    prettyPlot;
    xlim([0 100])
end

myfig = gcf;
myfig.Position=[50,50,414,323];

%return
myfittype = fittype('a*x');
myfit = fit(acoustic_energy_density(my_volt_list)',sigmastar_acous',myfittype,'StartPoint',1,'Weights',1./sigmastar_ci);
%sigmastarFit = @(V) CSS*sigmastar(1)+myfit.a*acoustic_energy_density(V);


%%
figure; hold on; 
xlabel('Acoustic energy density E_0 (Pa)'); ylabel('\sigma^*_a (Pa)');
makeAxesLogLog
for jj=1:length(my_volt_list)
    colorV = myColor(my_volt_list(jj));
    %errorbar(acoustic_energy_density(my_volt_list(jj)),sigmastar_acous(jj),CSS*sigmastar_ci(jj),'p','Color',colorV,'MarkerFaceColor',colorV,'MarkerSize',5,'LineWidth',1.5);
    plot(acoustic_energy_density(my_volt_list(jj)),sigmastar_acous(jj),'p','Color',colorV,'MarkerFaceColor',colorV,'MarkerSize',5,'LineWidth',1.5);
end
prettyPlot;

plot(acoustic_energy_density(V), myfit.a*acoustic_energy_density(V),'k-')
%plot(acoustic_energy_density(my_volt_list), acoustic_energy_density(my_volt_list),'k-')
plot(acoustic_energy_density(V),CSS*polyval([sigmastarFit.a sigmastarFit.b sigmastarFit.c],V)-CSS*sigmastar(1),'r-');

myfig = gcf;
myfig.Position=[50,50,414,323];

%%
return
figure; hold on; 
xlabel('E_0'); ylabel('\sigma^* (Pa)');
makeAxesLogLog
plot(acoustic_energy_density(my_volt_list),sigmastar*CSS,'o-');
plot(acoustic_energy_density(my_volt_list),sigmastarFit(my_volt_list));