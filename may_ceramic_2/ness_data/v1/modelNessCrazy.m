function [x,F,delta_F,F_hat,eta,delta_eta,eta_hat] = modelNessCrazy(stressTable, paramsVector)

%[eta0, phi0, delta, A, width, sigmastar, D] = unzipParamsHandpickedAll(paramsVector,13); 
eta0 = paramsVector(1);
phi0 = paramsVector(2);
delta = paramsVector(3);

phi_list = unique(stressTable(:,1));

N = size(stressTable,1);
x = zeros(N,1);
F = zeros(N,1);
delta_F = ones(N,1);
eta = zeros(N,1);
delta_eta = ones(N,1);

for kk = 1:N
    phi = stressTable(kk,1);
    
    ii = find(phi == phi_list);

    sigma = stressTable(kk,2);
    myEta = stressTable(kk,4);
    eta(kk) = myEta;        

    x(kk) = 1 - (myEta/eta0*(phi0-phi)^2)^(1/delta);
    F(kk) = myEta*(phi0-phi)^2;
    %delta_F(kk) = F(kk) .* (eta(kk).^(-2).*delta_eta_rheo.^2 + 4/(phi0-phi)^2*delta_phi^2 ).^(1/2);
end

% calculate F_hat from x
F_hat = eta0*(1-x).^delta;

eta_hat = zeros(N,1);
for kk = 1:N
    phi = stressTable(kk,1);
    eta_hat(kk) = F_hat(kk)*(phi0-phi)^-2;
end 



end