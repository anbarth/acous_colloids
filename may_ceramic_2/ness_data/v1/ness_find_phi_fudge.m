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
delta_eta_minushalf = 1/2 * eta.^(-3/2) .* delta_eta;


% fit to find phi0
ft1 = fittype('m*(phi0-x)');
opts = fitoptions(ft1);
opts.StartPoint = [16,0.67];
myFit1 = fit(phi,eta.^(-1/2),ft1,opts);
m = myFit1.m;
phi0 = myFit1.phi0;

ci = confint(myFit1);
phi0_err = (ci(2,2)-ci(1,2))/2;
%disp(phi0)
%disp(phi0_err)

phi_corrected = phi0-eta.^(-1/2)/m;
phi_fudge = phi_corrected - phi;

return

figure; hold on;
xlabel('\phi')
ylabel('\eta^{-1/2}');


errorbar(phi,eta.^(-1/2),delta_eta_minushalf,'ok')


plot([.45,.72],m*(phi0-[.45,.72]));
yline(0)
scatter(phi+phi_fudge, eta.^(-1/2),'rd');