optimize_sigmastarV_03_25;

% start with parameters where sigma*(V) and D(phi) are picked pt-by-pt
y_pointwise = y_fmincon; myModelHandle = @modelHandpickedSigmastarV;
confints = get_conf_ints(restricted_data_table,y_pointwise,myModelHandle);

% optionally plot things
makeSigmastarPlot = true;
correctSigmastarPlotUnits = true;
makeCollapsePlot = false;

% fit a quadratic to sigma*(V)
volt_list = [0 5 10 20 40 60 80];
sigmastar = y_pointwise(6:12);
sigmastar_err = confints(6:12);
s = sigmastar~=0;
sigmastar = sigmastar(s);
volt_list_restricted = volt_list(s);
sigmastar_err = sigmastar_err(s);

quadfit = fittype("a*x^2+b*x+c");
sigmastarFit = fit(volt_list_restricted',sigmastar',quadfit,'StartPoint',[0.0001, 0.0005, 0.07],'Weights',1./sigmastar_err);

quadParams = [sigmastarFit.a sigmastarFit.b sigmastarFit.c];

if makeSigmastarPlot
    figure; hold on;
    xlabel("Acoustic voltage {\itV} (V)")
    ylabel("\sigma^* (Pa)")
    CSS=1;
    if correctSigmastarPlotUnits
        CSS=19;
    end

    % quadratic interpolation
    V = linspace(0,80);
    plot(V,CSS*polyval(quadParams,V),'r-');

    % points with err bars
    cmap = plasma(256);
    myColor = @(V) cmap(round(1+255*V/80),:);
    for jj=1:length(volt_list_restricted)
        %plot(volt_list_restricted,sigmastar,'ko');
        colorV = myColor(volt_list_restricted(jj));
        %errorbar(volt_list_restricted(jj),CSS*sigmastar(jj),CSS*sigmastar_err(jj),'p','Color',colorV,'MarkerFaceColor',colorV,'MarkerSize',15,'LineWidth',1.5);
        plot(volt_list_restricted(jj),CSS*sigmastar(jj),'p','Color',colorV,'MarkerFaceColor',colorV,'MarkerSize',15,'LineWidth',1.5);
        prettyPlot;
        xlim([0 100])
    end
    
    myfig = gcf;
    myfig.Position=[1015,677,414,323];
    
end

% zip up the parameters
% altho this version is awkward bc the shape of the scaling fcn isnt
% optimized to this new set of parameters
y_smooth_restricted = y_pointwise;
y_smooth_restricted(6:12) =  polyval(quadParams, volt_list);

if makeCollapsePlot
    dataTable = may_ceramic_09_17;
    show_F_vs_x(dataTable,y_smooth_restricted,myModelHandle)
    show_F_vs_xc_x(dataTable,y_smooth_restricted,myModelHandle)
    [x,F,delta_F,F_hat,eta,delta_eta,eta_hat] = myModelHandle(dataTable, y_smooth_restricted);
end