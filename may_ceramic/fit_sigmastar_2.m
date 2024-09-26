%collapse_params;
%load("y_optimal_crossover_post_fudge_1percent_06_27.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13); fxnType = 2;
%load("y_09_04.mat"); y_optimal = y_handpicked_xcShifted_09_04; [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13);
%y_optimal = y_Cv;
load("y_09_04.mat"); y_optimal = y_handpicked_xcShifted_09_04;
[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13);

volt_list = [0,5,10,20,40,60,80];
V = linspace(0,80);

figure; hold on;


plot(volt_list,sigmastar,'ok','LineWidth',2);

%ft1 = fittype('a*x^2+b');
%opts = fitoptions(ft1);
%opts.StartPoint = [0.0001,0.3];
%myFit1 = fit(volt_list',sigmastar',ft1,opts);
%disp([myFit1.a myFit1.b])
%plot(V,myFit1.a*V.^2+myFit1.b,'-','LineWidth',1);

p = polyfit(volt_list,sigmastar,2);
plot(V,p(1)*V.^2+p(2)*V+p(3),'-','LineWidth',1);
disp(p);

xlabel('V')
ylabel('\sigma^* (Pa)')


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