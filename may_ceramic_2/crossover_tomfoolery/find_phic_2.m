dataTable = may_ceramic_09_17;
phi_list = unique(dataTable(:,1));
stress_list = unique(dataTable(:,2));

phi0=0.705;
phic=0.65;

sigma = stress_list(15);
disp(sigma)
eta = [];
delta_eta = [];
phi = [];
for ii=1:length(phi_list)

    myData = dataTable(dataTable(:,1)==phi_list(ii) & dataTable(:,3)==0, :);
    mySigma = myData(:,2);
    myEta = myData(:,4);
    myDeltaEta = myData(:,5);
        
    stressIndex = find(sigma==mySigma);
    if stressIndex
        eta(end+1) = myEta(stressIndex);
        delta_eta(end+1) = myDeltaEta(stressIndex);
        phi(end+1) = phi_list(ii);
    end
end

% transpose eta
eta = eta';
delta_eta = delta_eta';
phi = phi';

%figure; hold on; ax1=gca; ax1.XScale='log'; ax1.YScale='log';
%xlabel('\phi_0-\phi'); ylabel('\eta')
%plot(phi0-phi,eta,'o-');

figure; hold on;
xlabel('\phi')
ylabel('\eta^{-1/2} (Pa s)^{-1/2}');
delta_eta_minushalf = 1/2 * eta.^(-3/2) .* delta_eta;
errorbar(phi,eta.^(-1/2),delta_eta_minushalf,'ok')

figure; hold on; ax1=gca; ax1.XScale='log'; ax1.YScale='log';
xlabel('\phi_J-\phi'); ylabel('\eta')
plot(phic-phi,eta,'o-');