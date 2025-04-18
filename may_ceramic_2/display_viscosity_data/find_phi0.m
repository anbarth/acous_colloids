dataTable = may_ceramic_09_17;
phi = unique(dataTable(:,1));
beta=1.8;

%load("y_optimal_crossover_post_fudge_1percent_06_27.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13); 
phi_fudge = zeros(1,length(phi));
%load("y_09_04.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_handpicked_fudge_xcShifted_09_04,13); 

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
    lowStressIndex = find(0.01==mySigma);
    eta(end+1) = myEta(lowStressIndex);
    %delta_eta(end+1) = myDeltaEta(lowStressIndex);
    delta_eta_rheo = myDeltaEta(lowStressIndex);
    
    delta_phi=0.02;
    delta_eta_volumefraction = myEta(lowStressIndex)*2*(0.7-phi(ii))^(-1)*delta_phi;
    delta_eta(end+1) = sqrt(delta_eta_rheo^2+delta_eta_volumefraction^2);
end

% transpose eta
eta = eta';
delta_eta = delta_eta';

% add fudge factor
phi_fudged = phi+phi_fudge';

figure; hold on;
title(strcat('\beta=',num2str(beta)))
delta_eta_minushalf = 1/2 * eta.^(-3/2) .* delta_eta;
errorbar(phi,eta.^(-1/beta),delta_eta_minushalf,'ok')
%errorbar(phi_fudged,eta.^(-1/2),delta_eta_minushalf,'or')
xlabel('\phi')
ylabel('\eta^{-1/\beta} (Pa s)^{-1/\beta}');

ft1 = fittype('m*(phi0-x)');
opts = fitoptions(ft1);
opts.StartPoint = [16,0.67];
myFit1 = fit(phi,eta.^(-1/beta),ft1,opts);
m = myFit1.m;
phi0 = myFit1.phi0;
plot([.15,.72],m*(phi0-[.15,.72]));
yline(0)


ci = confint(myFit1);
phi0_err = (ci(2,2)-ci(1,2))/2;
disp(phi0)
disp(phi0_err)
