function [x,F,delta_F,F_hat,eta,delta_eta,eta_hat] = modelHandpickedAllExp0VBhatta(stressTable, y)

phi0 = y(1);
sigmastar = y(2);
D = y(3:end);

f = @(sigma) exp(-sigmastar./sigma);
phi_list = unique(stressTable(:,1));
volt_list = [0,5,10,20,40,60,80];

N = size(stressTable,1);
x = zeros(N,1);
F = zeros(N,1);
delta_F = zeros(N,1);
eta = zeros(N,1);
delta_eta = zeros(N,1);

for kk = 1:N
    phi = stressTable(kk,1);
    sigma = stressTable(kk,2);
    voltage = stressTable(kk,3);
    eta(kk) = stressTable(kk,4);        
    delta_eta_rheo = max(stressTable(kk,5),eta(kk)*0.05);
    delta_phi = 0.02;
    delta_eta_volumefraction = eta(kk)*2*(phi0-phi)^(-1)*delta_phi;
    delta_eta(kk) = sqrt(delta_eta_rheo.^2+delta_eta_volumefraction.^2);

    ii = find(phi == phi_list);
    jj = find(voltage == volt_list);

    x(kk) = D(ii)*f(sigma);
    F(kk) = eta(kk)*(phi0-phi)^2;
    delta_F(kk) = F(kk) .* (eta(kk).^(-2).*delta_eta_rheo.^2 + 4/(phi0-phi)^2*delta_phi^2 ).^(1/2);
end



F_hat = zeros(N,1);
eta_hat = zeros(N,1);



end