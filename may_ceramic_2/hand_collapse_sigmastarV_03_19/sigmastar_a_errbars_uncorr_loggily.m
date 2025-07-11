%optimize_sigmastarV_03_19;

makeVplot = false;
makeUplot = true;

y_pointwise = y_fmincon; myModelHandle = @modelHandpickedSigmastarV;
%[ci_u,ci_l] = get_conf_ints_loggily(may_ceramic_09_17,y_pointwise,myModelHandle);

sigmastar0 = y_pointwise(6);
%sigmastar0_ci = confIntsWithSigma0(6);

jacobian = numeric_jacobian_loggily(may_ceramic_09_17,y_pointwise,myModelHandle);
jacobian(:,6) = [];
hessian = transpose(jacobian)*jacobian;
variances = diag(pinv(hessian));
dof = size(jacobian,1)-size(jacobian,2); % dof = N-P
ci = sqrt(variances)*tinv(0.975,dof);
confInts_upper = ci;
confInts_lower = ci;
myParams = y_pointwise;
for paramNum=1:length(ci)
    param = myParams(paramNum);
    lowerBound = exp(log(param)-ci(paramNum));
    upperBound = exp(log(param)+ci(paramNum));
    confInts_lower(paramNum) = param - lowerBound;
    confInts_upper(paramNum) = upperBound - param;
end


sigmastar_tot = y_pointwise(7:12);
sigmastar_tot_ci_u = confInts_upper(6:11);
sigmastar_tot_ci_l = confInts_lower(6:11);
my_volt_list = [5 10 20 40 60 80];
s = sigmastar_tot~=0;
sigmastar_tot = sigmastar_tot(s);
my_volt_list = my_volt_list(s);


CSS=(50/19)^3;
sigmastar_acous = CSS*(sigmastar_tot-sigmastar0);
sigmastar_acous_ci_u = CSS*(sigmastar_tot_ci_u);
sigmastar_acous_ci_l = CSS*(sigmastar_tot_ci_l);

% if error bars extend below zero, replace with very small positive so that
% it shows up on a log log plot
sigmastar_a_lower = sigmastar_acous'-sigmastar_acous_ci_l;
sigmastar_a_lower(sigmastar_a_lower<0) = 1e-16;
sigmastar_acous_ci_l = sigmastar_acous'-sigmastar_a_lower;

% fit a line to sigma*_a(U)
myfittype = fittype('a*x');
myfit = fit(acoustic_energy_density(my_volt_list)',sigmastar_acous',myfittype,'StartPoint',1,'Weights',2./(sigmastar_acous_ci_l+sigmastar_acous_ci_u));





if makeUplot
    figure; hold on; 
    xlabel('Acoustic energy density {\itU_a} (Pa)'); ylabel('\sigma^*_a (Pa)');
    makeAxesLogLog
    xpts = logspace(-5,5);
    plot(xpts,xpts,'k--')

    logMinE0 = log(acoustic_energy_density(5));
    logMaxE0 = log(acoustic_energy_density(80));
    cmap = plasma(256);
    for jj=1:length(my_volt_list)
        U = acoustic_energy_density(my_volt_list(jj));
        colorU = cmap(round(1+255*(log(U)-logMinE0)/( logMaxE0-logMinE0 )),:);
        errorbar(U,sigmastar_acous(jj),sigmastar_acous_ci_l(jj),sigmastar_acous_ci_u(jj),'ok','MarkerSize',5,'LineWidth',1.5);
    end
    prettyPlot;
    
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