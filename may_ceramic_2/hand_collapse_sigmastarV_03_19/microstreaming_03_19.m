%optimize_sigmastarV_03_19;

% start with parameters where sigma*(V) and D(phi) are picked pt-by-pt
y_pointwise = y_fmincon; myModelHandle = @modelHandpickedSigmastarV;
confInts = get_conf_ints(may_ceramic_09_17,y_pointwise,myModelHandle);

% optionally plot things
makeSigmastarPlot = true;
correctSigmastarPlotUnits = true;


% fit a quadratic to sigma*
sigmastar = y_pointwise(6:12);
sigmastar_ci = confInts(6:12);
volt_list = [0 5 10 20 40 60 80];
s = sigmastar~=0;
sigmastar = sigmastar(s);
my_volt_list = volt_list(s);
quadfit = fittype("a*x^2+b*x+c");
%sigmastarFit = fit(my_volt_list',sigmastar',quadfit,'StartPoint',[0.0001, 0.0005, 0.07]);
sigmastarFit = fit(my_volt_list',sigmastar',quadfit,'StartPoint',[0.0001, 0.0005, 0.07],'Weights',1./sigmastar_ci);

d33 = 300e-12;
rho = 1200;
c = 2000;
f = 1.15e6;
k = 2*pi*f/c;
stress_microstreaming = @(V) (rho*c^2*k*V*d33).^2 ./ (2*rho*c^2);

CSS=1;
if correctSigmastarPlotUnits
    CSS=(50/19)^3;
end

sigmastar_acous = CSS*(sigmastar-sigmastar(1));

%return
%%
figure; hold on; 
xlabel('Acoustic voltage {\itV} (V)'); ylabel('\sigma^*_a (Pa)');

% quadratic interpolation
V = linspace(0,80);
plot(V,stress_microstreaming(V),'r-');
%plot(V,CSS*polyval([sigmastarFit.a sigmastarFit.b sigmastarFit.c],V),'r-');

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
    
%%
figure; hold on; 
xlabel('E_0'); ylabel('\sigma^*_a (Pa)');
%makeAxesLogLog
plot(stress_microstreaming(my_volt_list),sigmastar_acous,'o-');
%errorbar(stress_microstreaming(my_volt_list),sigmastar_acous,sigmastar_ci*CSS,'o-');
myfittype = fittype('a*x');
myfit = fit(stress_microstreaming(my_volt_list)',sigmastar_acous',myfittype);
plot(stress_microstreaming(my_volt_list), myfit.a*stress_microstreaming(my_volt_list),'r-')
plot(stress_microstreaming(my_volt_list), stress_microstreaming(my_volt_list),'k-')

%%
figure; hold on; 
xlabel('V'); ylabel('\sigma^*/E_0 (Pa)');
%makeAxesLogLog
plot(my_volt_list,sigmastar_acous./stress_microstreaming(my_volt_list),'o-');
