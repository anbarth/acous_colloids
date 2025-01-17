% find phi0, but use a log-log plot of eta vs phi
% (instead of assuming the low-stress power law is -2)

dataTable = ness_data_table;
phi = unique(dataTable(:,1));

eta = [];
delta_eta = [];
for ii=1:length(phi)

    myData = dataTable(dataTable(:,1)==phi(ii) & dataTable(:,3)==0, :);
    mySigma = myData(:,2);
    myEta = myData(:,4);
    myDeltaEta = myData(:,5);
    
    % grab eta for lowest sigma
    %[~,lowStressIndex] = min(sigma); 
    
    % actually just grab the value at 0.03pa to avoid low stress weirdness?
    %lowStressIndex = find(0.02==mySigma | 0.03==mySigma);
    lowStressIndex = find(1e-4==mySigma);
    eta(end+1) = myEta(lowStressIndex);
    delta_eta(end+1) = myDeltaEta(lowStressIndex);
end

% transpose eta
eta = eta';
delta_eta = delta_eta';


figure; hold on; ax1=gca; ax1.XScale='log'; ax1.YScale='log';
phi0 = 0.640;
dphi = phi0-phi;

dphi=dphi(1:end-2);
eta=eta(1:end-2);

plot(dphi, eta,'o-');
p = polyfit(log(dphi), log(eta),1);
plot(dphi,exp(polyval(p,log(dphi))),'-r');
disp(p(1))
