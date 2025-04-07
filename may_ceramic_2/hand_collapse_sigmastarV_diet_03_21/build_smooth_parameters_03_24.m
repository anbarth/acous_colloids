optimize_sigmastarV_03_21;

% start with parameters where sigma*(V) and D(phi) are picked pt-by-pt
y_pointwise = y_fmincon; myModelHandle = @modelHandpickedSigmastarV;
confints = get_conf_ints(restricted_data_table,y_pointwise,myModelHandle);

% optionally plot things
makeSigmastarPlot = true;
makeDplot = true;
makeCplot = true;
makeCollapsePlot = true;

% fit a quadratic to sigma*(V)
volt_list = [0 5 10 20 40 60 80];
sigmastar = y_pointwise(6:12);
sigmastar_err = confints(6:12);
s = sigmastar~=0;
sigmastar = sigmastar(s);
volt_list_restricted = volt_list(s);
sigmastar_err = sigmastar_err(s);

quadParams = polyfit(volt_list_restricted,sigmastar,2);

if makeSigmastarPlot
    figure; hold on;
    xlabel("Acoustic voltage V")
    ylabel("\sigma^* (Pa)")
    plot(volt_list_restricted,sigmastar,'ko');
    %errorbar(volt_list_restricted,sigmastar,sigmastar_err,'ko')

    V = linspace(0,80);
    plot(V,polyval(quadParams,V),'r-');
end

% extract alpha from D
% this step is actually p hard to accomplish... see 3/24 lab log for thoughts
% but for now let's just use alpha from the full fit
D = y_pointwise(13:end);
D_err = confints(13:end);
phi0 = y_pointwise(2);
dphi = phi0-phi_list;

s = D~=0;
D = D(s);
D_err = D_err(s);
dphi = dphi(s);
my_phi_list = phi_list(s);

l2 = my_phi_list>0.52; % this is the cutoff ive been using
linearfit = fittype('poly1');
myft2 = fit(log(dphi(l2)),log(D(l2))',linearfit);
%alpha = -myft2.p1;

% alpha from smoothen_C_03_19
alpha = 0.0106;

if makeDplot
    figure; hold on;
    xlabel('\phi_0-\phi')
    ylabel('D')
    plot(dphi,D,'ko');
    errorbar(dphi,D,D_err,'ko')
    plot(dphi(l2),exp(myft2.p2)*dphi(l2).^(-alpha)/1.02,'b-')
end

% fit a logistic curve to C
C = D'.*dphi.^alpha;
logistic = @(L,k,x0,x) L./(1+exp(-k*(x-x0)));
logisticFit = fittype(logistic);
cFit = fit(my_phi_list,C,logisticFit,'StartPoint',[0.95, 50, 0.4],'Weights',1./D_err);
%cFit = fit(my_phi_list,C,logisticFit,'StartPoint',[0.95, 50, 0.4]);

if makeCplot
    figure; hold on;
    xlabel('\phi'); ylabel('C')
    plot(my_phi_list,C,'ko')
    errorbar(my_phi_list,C,D_err,'ko')
    plot(phi_list,logistic(cFit.L,cFit.k,cFit.x0,phi_list));
end

% zip up the parameters
% altho this version is awkward bc the shape of the scaling fcn isnt
% optimized to this new set of parameters
y_smooth_restricted = [y_pointwise(1:5) quadParams alpha cFit.L cFit.k cFit.x0];
%show_F_vs_x(restricted_data_table,y_smooth_restricted,@modelLogisticCSigmastarV,'ShowInterpolatingFunction',true,'ShowErrorBars',true)
%show_F_vs_xc_x(restricted_data_table,y_smooth_restricted,@modelLogisticCSigmastarV,'ShowInterpolatingFunction',true,'ShowErrorBars',true)

if makeCollapsePlot
    dataTable = may_ceramic_09_17;
    show_F_vs_x(dataTable,y_smooth_restricted,@modelLogisticCSigmastarV)
    show_F_vs_xc_x(dataTable,y_smooth_restricted,@modelLogisticCSigmastarV)
    [x,F,delta_F,F_hat,eta,delta_eta,eta_hat] = modelLogisticCSigmastarV(dataTable, y_smooth_restricted);
end