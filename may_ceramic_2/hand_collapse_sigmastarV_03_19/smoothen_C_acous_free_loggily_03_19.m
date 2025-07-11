optimize_C_jardy_03_19;

%optimize_C_powerlaw_03_19;
%optimize_C_logsigmastar_03_19;

% start with parameters where D(phi) is picked pt-by-pt
y_pointwise = y_lsq_0V; 
myModelHandle = @modelHandpickedAllExp0V;
%myModelHandle = @modelHandpickedAllExpPowerLawF0V;
%myModelHandle = @modelHandpickedAllExp0V_logsigmastar;
acoustics_free_data = may_ceramic_09_17(may_ceramic_09_17(:,3)==0,:);
[confInts_u,confInts_l] = get_conf_ints_loggily(acoustics_free_data,y_pointwise,myModelHandle);

% optionally plot things
makeDplot = false;
makeBplot = false;
makeCplot = true;
makeCollapsePlot = false;

% extract alpha from D
D = y_pointwise(7:end);
D_ci_u = confInts_u(7:end);
D_ci_l = confInts_l(7:end);
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
    errorbar(dphi,D,D_ci_l,D_ci_u,'ko','MarkerFaceColor','k');
    plot(dphi(l2),dphi(l2).^myft2.p1*exp(myft2.p2),'b-')
    prettyPlot;
    ylim([7e-9 2])
    xlim([0.07 0.6])
    myfig = gcf;
    myfig.Position=[100,100,414,323];
end

% fit a logistic curve to C
B = D'.*dphi.^alpha;
logistic = @(L,k,x0,x) L./(1+exp(-k*(x-x0)));
logisticFit = fittype(logistic);
%cFit = fit(phi_list,C,logisticFit,'StartPoint',[0.95, 50, 0.4]);
cFit = fit(phi_list,B,logisticFit,'StartPoint',[0.95, 50, 0.4],'Weights',1./D_ci_l);

if makeBplot
    figure; hold on;
    xlabel('\phi'); ylabel('B')
    %plot(phi_list,C,'ko')
    errorbar(phi_list,B,D_ci_l,D_ci_u,'ko','MarkerFaceColor','k')

    phifake = linspace(min(phi_list),max(phi_list));
    plot(phifake,logistic(cFit.L,cFit.k,cFit.x0,phifake));
    xlim([0.1 0.7])
    prettyPlot;
    myfig = gcf;
    myfig.Position=[100,100,414,323];
end

if makeCplot
    C = D'.*dphi;
    C_ci_u = D_ci_u.*dphi;
    C_ci_l = D_ci_l.*dphi;

    figure; hold on;
    xlabel('\phi'); ylabel('C')
    %plot(phi_list,C,'ko')
    errorbar(phi_list,C,C_ci_l,C_ci_u,'ko','MarkerFaceColor','k')
    xlim([0.1 0.7])
    prettyPlot;
    myfig = gcf;
    myfig.Position=[100,100,414,323];
end

y = y_pointwise;
y(7:end) = dphi.^(-alpha) .* logistic(cFit.L,cFit.k,cFit.x0,phi_list);

if makeCollapsePlot
    dataTable = acoustics_free_data;
    show_F_vs_x(dataTable,y,myModelHandle,'ColorBy',2)
    show_F_vs_xc_x(dataTable,y,myModelHandle,'ColorBy',2)
    [x,F,delta_F,F_hat,eta,delta_eta,eta_hat] = myModelHandle(dataTable, y);
end