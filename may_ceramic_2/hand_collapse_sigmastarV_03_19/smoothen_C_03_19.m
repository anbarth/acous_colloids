optimize_sigmastarV_03_19;

% start with parameters where sigma*(V) and D(phi) are picked pt-by-pt
y_pointwise = y_fmincon; myModelHandle = @modelHandpickedSigmastarV;
confInts = get_conf_ints(may_ceramic_09_17,y_pointwise,myModelHandle);

% optionally plot things
makeSigmastarPlot = false;
makeDplot = true;
makeCplot = true;

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
cFit = fit(phi_list,C,logisticFit,'StartPoint',[0.95, 50, 0.4]);%,'Weights',1./D_err);

if makeCplot
    figure; hold on;
    xlabel('\phi'); ylabel('C')
    plot(phi_list,C,'ko')
    plot(phi_list,logistic(cFit.L,cFit.k,cFit.x0,phi_list));
end

y = [y_pointwise(1:5) ]
