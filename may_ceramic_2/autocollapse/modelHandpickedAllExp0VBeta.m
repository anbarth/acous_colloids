function [x,F,delta_F,F_hat,eta,delta_eta,eta_hat] = modelHandpickedAllExp0VBeta(stressTable, y)

eta0 = y(1);
phi0 = y(2);
delta = y(3);
A = y(4);
width = y(5);
sigmastar = y(6);
D = y(7:end-1);
beta = y(end);

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
    F(kk) = eta(kk)*(phi0-phi)^beta;
    delta_F(kk) = F(kk) .* (eta(kk).^(-2).*delta_eta_rheo.^2 + 4/(phi0-phi)^2*delta_phi^2 ).^(1/2);
end

% calculate F_hat from x
alpha=1;
xi = x.^(-1/alpha)-1;
xi0 = (A/eta0)^(1/(-beta-delta));

H_hat = sqrt(A*eta0)*xi.^((-beta+delta)/2) .* ((xi/xi0).^width+(xi/xi0).^(-width)).^((-beta-delta)/(2*width));

F_hat = 1./x.^(beta/alpha) .* H_hat;

eta_hat = zeros(N,1);
for kk = 1:N
    phi = stressTable(kk,1);
    eta_hat(kk) = F_hat(kk)*(phi0-phi)^-beta;
end 



end