dataTable = may_ceramic_06_06;
phi = unique(dataTable(:,1));

% TODO idk if these are correct for the low phis
massRatios = [1.4363/3.0190,... % 20
1.9441/3.0564,... % 25    
1.8276/2.2415,... % 30
1.9913/1.9414,... % 35
2.1230/1.6656,...  % 40
2.5817/1.7199,... % 44
2.8872/1.6347,... % 48
3.8603/1.8760,... % 52
3.3710/1.5086,... % 54
3.6379/1.4963,... % 56
3.9990/1.4601]; % 59

d = 2.4/1.26;
phi_alter = massRatios ./ (massRatios + d);

eta = [];
delta_eta = [];
for ii=1:length(phi)

    myData = dataTable(dataTable(:,1)==phi(ii) & dataTable(:,3)==0, :);
    mySigma = myData(:,2);
    myEta = myData(:,4);
    myDeltaEta = myData(:,5);

    lowStressIndex = find(0.01==mySigma);
    eta(end+1) = myEta(lowStressIndex);
    delta_eta(end+1) = myDeltaEta(lowStressIndex);
end

% transpose eta
eta = eta';
delta_eta = delta_eta';
phi_alter = phi_alter';

figure; hold on;
delta_eta_minushalf = 1/2 * eta.^(-3/2) .* delta_eta;
errorbar(phi_alter,eta.^(-1/2),delta_eta_minushalf,'o')
xlabel('\phi')
ylabel('\eta^{-1/2} (Pa s)^{-1/2}');

ft1 = fittype('m*(phi0-x)');
opts = fitoptions(ft1);
opts.StartPoint = [16,0.67];
myFit1 = fit(phi_alter,eta.^(-1/2),ft1,opts);
m = myFit1.m;
phi0 = myFit1.phi0;
plot([.15,.7],m*(phi0-[.15,.7]));


ci = confint(myFit1);
phi0_err = (ci(2,2)-ci(1,2))/2;
disp(phi0)
disp(phi0_err)



%p = polyfit(phi,eta.^(-1/2),1);
%disp(-p(2)/p(1))
%plot([.15,.65],p(1)*[.15,.65]+p(2));
