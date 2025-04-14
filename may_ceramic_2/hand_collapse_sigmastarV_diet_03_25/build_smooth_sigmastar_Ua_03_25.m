optimize_sigmastarV_03_25;

% start with parameters where sigma*(V) and D(phi) are picked pt-by-pt
y_pointwise = y_fmincon; myModelHandle = @modelHandpickedSigmastarV;
confints = get_conf_ints(restricted_data_table,y_pointwise,myModelHandle);

% optionally plot things
makeSigmastarPlot = true;
makeCollapsePlot = false;
CSS=(50/19)^3;


volt_list = [0 5 10 20 40 60 80];
E_list = acoustic_energy_density(volt_list);
sigmastar = y_pointwise(6:12); % rheo units
sigmastar_err = confints(6:12);

s = sigmastar~=0;
sigmastar = sigmastar(s);
sigmastar0V = sigmastar(1);
sigmastar_acous = sigmastar-sigmastar0V;
volt_list_restricted = volt_list(s);
E_list_restricted = E_list(s);
sigmastar_err = sigmastar_err(s);

% fit sigma*_acous(U) to a line
linfit = fittype("a*x");
sigmastarFitParam = fit(E_list_restricted',sigmastar_acous',linfit,'StartPoint',1,'Weights',1./sigmastar_err);

sigmastarFit = @(V) sigmastar0V + sigmastarFitParam.a*acoustic_energy_density(V);
sigmastar_aFit = @(V) sigmastarFitParam.a*acoustic_energy_density(V);

if makeSigmastarPlot
    figure; hold on;
    xlabel("Acoustic energy density {\itU_a} (Pa)")
    ylabel("\sigma^*_a (Pa)")


    % quadratic interpolation
    V = linspace(0,80);
    plot(acoustic_energy_density(V),CSS*sigmastar_aFit(V),'r-');

    % points with err bars
    cmap = plasma(256);
    logMinE0 = log(acoustic_energy_density(5));
    logMaxE0 = log(acoustic_energy_density(80));
    myColor = @(U) cmap(round(1+255*(log(U)-logMinE0)/( logMaxE0-logMinE0 )),:);
    for jj=2:length(volt_list_restricted)

        colorV = myColor(acoustic_energy_density(volt_list_restricted(jj)));

        plot(acoustic_energy_density(volt_list_restricted(jj)),CSS*(sigmastar_acous(jj)),'p','Color',colorV,'MarkerFaceColor',colorV,'MarkerSize',5,'LineWidth',1.5);
        %errorbar(acoustic_energy_density(volt_list_restricted(jj)),CSS*(sigmastar_acous(jj)),CSS*sigmastar_err(jj),'p','Color',colorV,'MarkerFaceColor',colorV,'MarkerSize',5,'LineWidth',1.5);

        prettyPlot;
        %xlim([0 100])
    end

    for volt=[5 20 80]
        colorV = myColor(acoustic_energy_density(volt));
        %plot(volt,CSS*polyval(quadParams,volt),'p','MarkerFaceColor',colorV,'MarkerSize',5,'LineWidth',1.5);
        plot(acoustic_energy_density(volt),CSS*sigmastar_aFit(volt),'p','MarkerFaceColor',colorV,'MarkerSize',10,'MarkerEdgeColor','r');
    end

    
    myfig = gcf;
    myfig.Position=[50,50,414,323];
    makeAxesLogLog
    xlim([0.03 30])
    xticks([10^-1 10^0 10^1])
    ylim([0.03 30])
    yticks([10^-1 10^0 10^1])
    
end

% zip up the parameters
% altho this version is awkward bc the shape of the scaling fcn isnt
% optimized to this new set of parameters
%return
y_smooth_restricted = y_pointwise;
y_smooth_restricted(6:12) =  sigmastar0V + sigmastar_aFit(volt_list);

if makeCollapsePlot
    dataTable = may_ceramic_09_17;
    show_F_vs_x(dataTable,y_smooth_restricted,myModelHandle)
    show_F_vs_xc_x(dataTable,y_smooth_restricted,myModelHandle)
    [x,F,delta_F,F_hat,eta,delta_eta,eta_hat] = myModelHandle(dataTable, y_smooth_restricted);
end