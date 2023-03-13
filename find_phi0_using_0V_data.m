phisToInclude = [0.2,0.25,0.3,0.35,0.4,0.44,0.46,0.48,0.5,0.52,0.53];%,0.53,0.54,0.55];
%phisToInclude = [0.44,0.46,0.48,0.5,0.52,0.53,0.54,0.55];
phi = [44,46,48,50,52,53,54,55];
for ii = 1:length(phi)
    matFileName = strcat('phi_0',num2str(phi(ii)),'.mat');
    load(matFileName);
end
phi = phi/100;
eta = zeros(size(phi));
data_by_vol_frac = {phi_044,phi_046,phi_048,phi_050,phi_052,phi_053,phi_054,phi_055};

for ii = 1:length(data_by_vol_frac)    
    phi_data = data_by_vol_frac{ii};
    myEta = phi_data(1,1); % take the lowest-stress viscosity
    eta(ii) = myEta; 
end

% add in low vol fracs from sigma_1Pa const stress run, last value
phi = [0.2,0.25,0.3,0.35,0.4,phi];
eta = [0.2102, 0.2590, 0.3718, 0.5918, 0.7999,eta];
%eta = [0.3059,0.3665,0.4434,0.6352,0.8006,eta]; % old values, where come from??

% only include the values specified at the top
include_me = false(length(phi),1);
for ii=1:length(phi)
    if any(phisToInclude==phi(ii))
        include_me(ii) = true;
    end
end
phi = phi(include_me);
eta = eta(include_me);


figure; hold on;
scatter(phi,1./sqrt(eta));
P = polyfit(phi,1./sqrt(eta),1);
sqrtEtaFit = P(1)*phi+P(2);
plot(phi,sqrtEtaFit,'r-');

xlabel('\phi')
ylabel('\eta^{-1/2}')

disp(-1*P(2)/P(1));
