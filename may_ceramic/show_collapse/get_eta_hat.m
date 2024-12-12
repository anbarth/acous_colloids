function [eta_hat, eta, delta_eta] = get_eta_hat(stressTable, paramsVector, phi_list, volt_list)

alpha=1;

if nargin < 3
    phi_list = unique(stressTable(:,1));
end
if nargin < 4
    volt_list = unique(stressTable(:,3));
end


[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(paramsVector,length(phi_list));

[F_hat,~,~] = get_F_hat(stressTable, paramsVector, phi_list, volt_list);

eta = zeros(size(F_hat));
eta_hat = zeros(size(F_hat));
delta_eta = zeros(size(F_hat));

for kk = 1:size(stressTable,1)
    phi = stressTable(kk,1);
    my_phi_fudge = phi_fudge(phi == phi_list);
    phi_fudged = phi+my_phi_fudge;

    eta(kk) = stressTable(kk,4);

    deltaEta_rheometer = max(stressTable(kk,5),eta(kk)*0.05);
    deltaPhi = 0.01;
    deltaEta_volumefraction = eta(kk)*2*(phi0-phi_fudged)^(-1)*deltaPhi;
    delta_eta(kk) = deltaEta_rheometer;
    %delta_eta(kk) = sqrt(deltaEta_rheometer.^2+deltaEta_volumefraction.^2);

    eta_hat(kk) = F_hat(kk) / (phi0 - phi_fudged)^2;
    
end


end