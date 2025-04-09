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

%return
if makeSigmastarPlot
    figure; hold on; 
    xlabel('Acoustic voltage {\itV} (V)'); ylabel('\sigma^* (Pa)');
    CSS=1;
    if correctSigmastarPlotUnits
        CSS=19;
    end

    % quadratic interpolation
    V = linspace(0,80);
    plot(V,stress_microstreaming(V),'r-');
    %plot(V,CSS*polyval([sigmastarFit.a sigmastarFit.b sigmastarFit.c],V),'r-');

    % points with err bars
    cmap = plasma(256);
    myColor = @(V) cmap(round(1+255*V/80),:);
    for jj=1:length(my_volt_list)
        colorV = myColor(my_volt_list(jj));
        plot(my_volt_list(jj),CSS*(sigmastar(jj)-sigmastar(1)),'p','Color',colorV,'MarkerFaceColor',colorV,'MarkerSize',15,'LineWidth',1.5);
        
        prettyPlot;
        xlim([0 100])
    end

    myfig = gcf;
    myfig.Position=[50,50,414,323];
    
end

y = [y_pointwise(1:5) sigmastarFit.a sigmastarFit.b sigmastarFit.c alpha cFit.L cFit.k cFit.x0];

if makeCollapsePlot
    dataTable = may_ceramic_09_17;
    show_F_vs_x(dataTable,y,@modelLogisticCSigmastarV)
    show_F_vs_xc_x(dataTable,y,@modelLogisticCSigmastarV)
    [x,F,delta_F,F_hat,eta,delta_eta,eta_hat] = modelLogisticCSigmastarV(dataTable, y);
end