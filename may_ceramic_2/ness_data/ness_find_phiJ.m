dataTable = ness_data_table;
phi = unique(dataTable(:,1));

stress_list = [1e-2 1 10 100];
phiJ_list = [0.65 0.6 0.59 0.59];
stressNum = 3;
stress = stress_list(stressNum);
phiJ = phiJ_list(stressNum);

%stress=10;

eta = [];
delta_eta = [];
phi_included = [];
for ii=1:length(phi)

    myData = dataTable(dataTable(:,1)==phi(ii) & dataTable(:,3)==0, :);
    mySigma = myData(:,2);
    myEta = myData(:,4);
    myDeltaEta = myData(:,5);
    
    % grab eta for lowest sigma
    %[~,lowStressIndex] = min(sigma); 
    
    % actually just grab the value at 0.03pa to avoid low stress weirdness?
    %lowStressIndex = find(0.02==mySigma | 0.03==mySigma);
    highStressIndex = find(stress==mySigma);
    if highStressIndex
        eta(end+1) = myEta(highStressIndex);
        delta_eta(end+1) = myDeltaEta(highStressIndex);
        phi_included(end+1) = phi(ii);
    end
end

% transpose eta
eta = eta';
delta_eta = delta_eta';


figure; hold on; ax1=gca; ax1.XScale='log'; ax1.YScale='log';
dphi = phiJ-phi_included;
plot(dphi, eta,'-o');
p = polyfit(log(dphi), log(eta),1);
plot(dphi,exp(polyval(p,log(dphi))),'-r');
disp(p(1)) % display the exponent

%figure; hold on;
%plot(phi_included,eta.^(-1/2),'-o')