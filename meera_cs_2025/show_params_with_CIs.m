optimize_collapse;

confInts = get_conf_ints(dataTable,y,myModelHandle);
confInts = confInts';

disp('eta_0')
disp([y(1) confInts(1)])
disp('phi_0')
disp([y(2) confInts(2)])
disp('delta')
disp([y(3) confInts(3)])
disp('A')
disp([y(4) confInts(4)])
disp('width')
disp([y(5) confInts(5)])
disp('sigma*')
disp([y(6) confInts(6)])

% find alpha
D = y(7:end);
D_ci = confInts(7:end);
phi0 = y(2);
dphi = phi0-phi_list;
cutoff_dphi = 0.17;
fitregion = dphi < cutoff_dphi;

linearfit = fittype('poly1');
myft2 = fit(log(dphi(fitregion)),log(D(fitregion))',linearfit);
alpha = -myft2.p1;
figure; hold on; makeAxesLogLog; errorbar(phi0-phi_list,D,D_ci,'ko'); prettyplot;
plot(dphi(fitregion),dphi(fitregion).^myft2.p1*exp(myft2.p2),'b-')