%optimize_sigmastarV_03_19;

makeVplot = false;
makeUplot = true;

y_pointwise = y_fmincon; myModelHandle = @modelHandpickedSigmastarV;
confIntsWithSigma0 = get_conf_ints(may_ceramic_09_17,y_pointwise,myModelHandle);

sigmastar0 = y_pointwise(6);
sigmastar0_ci = confIntsWithSigma0(6);

jacobian = numeric_jacobian(may_ceramic_09_17,y_pointwise,myModelHandle);
jacobian(:,6) = [];
hessian = transpose(jacobian)*jacobian;
variances = diag(pinv(hessian));
dof = size(jacobian,1)-size(jacobian,2); % dof = N-P
confInts = sqrt(variances)*tinv(0.975,dof);


sigmastar_tot = y_pointwise(7:12);
sigmastar_tot_ci = confInts(6:11);
my_volt_list = [5 10 20 40 60 80];
s = sigmastar_tot~=0;
sigmastar_tot = sigmastar_tot(s);
my_volt_list = my_volt_list(s);


CSS=(50/19)^3;
sigmastar_acous = CSS*(sigmastar_tot-sigmastar0);
sigmastar_acous_ci = CSS*(sigmastar_tot_ci);

% fit a line to sigma*_a(U)
myfittype = fittype('a*x');
myfit = fit(acoustic_energy_density(my_volt_list)',sigmastar_acous',myfittype,'StartPoint',1,'Weights',1./sigmastar_acous_ci);





if makeUplot
    figure; hold on; 
    xlabel('Acoustic energy density {\itU_a} (Pa)'); ylabel('\sigma^*_a (Pa)');
    makeAxesLogLog
    plot(acoustic_energy_density(my_volt_list), acoustic_energy_density(my_volt_list),'k--')

    logMinE0 = log(acoustic_energy_density(5));
    logMaxE0 = log(acoustic_energy_density(80));
    cmap = plasma(256);
    for jj=1:length(my_volt_list)
        U = acoustic_energy_density(my_volt_list(jj));
        colorU = cmap(round(1+255*(log(U)-logMinE0)/( logMaxE0-logMinE0 )),:);
        %errorbar(acoustic_energy_density(my_volt_list(jj)),sigmastar_acous(jj),CSS*sigmastar_ci(jj),'p','Color',colorV,'MarkerFaceColor',colorV,'MarkerSize',5,'LineWidth',1.5);
        %plot(U,sigmastar_acous(jj),'o','Color',colorU,'MarkerFaceColor',colorU,'MarkerSize',5,'LineWidth',1.5);
        errorbar(U,sigmastar_acous(jj),sigmastar_acous_ci(jj),'ok','MarkerSize',5,'LineWidth',1.5);
    end
    prettyPlot;
    
    %plot(acoustic_energy_density(V), myfit.a*acoustic_energy_density(V),'k-')
    %plot(acoustic_energy_density(V),CSS*polyval([sigmastarFit.a sigmastarFit.b sigmastarFit.c],V)-CSS*sigmastar(1),'r-');
    
    myfig = gcf;
    myfig.Position=[50,50,414,323];
    xlim([0.03 30])
    xticks([10^-1 10^0 10^1])
    ylim([0.03 30])
    yticks([10^-1 10^0 10^1])
end


return
figure; hold on; 
xlabel('E_0'); ylabel('\sigma^* (Pa)');
makeAxesLogLog
plot(acoustic_energy_density(my_volt_list),sigmastar_tot*CSS,'o-');
plot(acoustic_energy_density(my_volt_list),sigmastarFit(my_volt_list));