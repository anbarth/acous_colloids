optimize_sigmastarV_03_19;

% start with parameters where sigma*(V) and D(phi) are picked pt-by-pt
y_pointwise = y_fmincon; myModelHandle = @modelHandpickedSigmastarV;
confInts = get_conf_ints(may_ceramic_09_17,y_pointwise,myModelHandle);

% optionally plot things
makeSigmastarPlot = true;
correctSigmastarPlotUnits = true;
makeDplot = false;
makeCplot = false;
makeCollapsePlot = false;

% extract alpha from D
D = y_pointwise(13:end);
D_ci = confInts(13:end);
phi0 = y_pointwise(2);
dphi = phi0-phi_list;
l2 = 10:13;

linearfit = fittype('poly1');
myft2 = fit(log(dphi(l2)),log(D(l2))',linearfit);
alpha = -myft2.p1;

if makeDplot
    figure; hold on; makeAxesLogLog;
    xlabel('\phi_0-\phi')
    ylabel('D')
    errorbar(dphi,D,D_ci,'ko');
    plot(dphi(l2),dphi(l2).^myft2.p1*exp(myft2.p2),'b-')
end

% fit a logistic curve to C
C = D'.*dphi.^alpha;
logistic = @(L,k,x0,x) L./(1+exp(-k*(x-x0)));
logisticFit = fittype(logistic);
%cFit = fit(phi_list,C,logisticFit,'StartPoint',[0.95, 50, 0.4]);
cFit = fit(phi_list,C,logisticFit,'StartPoint',[0.95, 50, 0.4],'Weights',1./D_ci);

if makeCplot
    figure; hold on;
    xlabel('\phi'); ylabel('C')
    %plot(phi_list,C,'ko')
    errorbar(phi_list,C,D_ci,'ko')
    plot(phi_list,logistic(cFit.L,cFit.k,cFit.x0,phi_list));
end

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


%return
if makeSigmastarPlot
    figure; hold on; 
    xlabel('Acoustic voltage {\itV} (V)'); ylabel('\sigma^* (Pa)');
    CSS=1;
    if correctSigmastarPlotUnits
        CSS=(50/19)^3;
    end

    % quadratic interpolation
    V = linspace(0,80);
    plot(V,CSS*polyval([sigmastarFit.a sigmastarFit.b sigmastarFit.c],V),'r-');

    % points with err bars
    cmap = plasma(256);
    myColor = @(V) cmap(round(1+255*V/80),:);
    for jj=1:length(my_volt_list)
        colorV = myColor(my_volt_list(jj));
        %errorbar(my_volt_list(jj),CSS*sigmastar(jj),CSS*sigmastar_ci(jj),'p','Color',colorV,'MarkerFaceColor',colorV,'MarkerSize',15,'LineWidth',1.5);
        plot(my_volt_list(jj),CSS*sigmastar(jj),'p','Color',colorV,'MarkerFaceColor',colorV,'MarkerSize',15,'LineWidth',1.5);
        prettyPlot;
        xlim([0 100])
    end

    myfig = gcf;
    myfig.Position=[1015,677,414,323];
    
end

y = [y_pointwise(1:5) sigmastarFit.a sigmastarFit.b sigmastarFit.c alpha cFit.L cFit.k cFit.x0];

if makeCollapsePlot
    dataTable = may_ceramic_09_17;
    show_F_vs_x(dataTable,y,@modelLogisticCSigmastarV)
    show_F_vs_xc_x(dataTable,y,@modelLogisticCSigmastarV)
    [x,F,delta_F,F_hat,eta,delta_eta,eta_hat] = modelLogisticCSigmastarV(dataTable, y);
end