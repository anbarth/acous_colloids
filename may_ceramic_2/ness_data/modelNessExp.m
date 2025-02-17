function [x,F,delta_F,F_hat,eta,delta_eta,eta_hat] = modelNessExp(stressTable, paramsVector)

%[eta0, phi0, delta, A, width, sigmastar, D] = unzipParamsHandpickedAll(paramsVector,13); 
eta0 = paramsVector(1);
phi0 = paramsVector(2);
delta = paramsVector(3);
A = paramsVector(4);
width = paramsVector(5);
sigmastar = paramsVector(6);
D = paramsVector(7:end);

f = @(sigma) exp(-sigmastar./sigma);
%f = @(sigma) sigma./(sigmastar+sigma);
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
    eta(kk) = stressTable(kk,4);        
    %delta_eta_rheo = max(stressTable(kk,5),eta(kk)*0.05);
    %delta_phi = 0.01;
    %delta_eta_volumefraction = eta(kk)*2*(phi0-phi)^(-1)*delta_phi;
    %delta_eta(kk) = sqrt(delta_eta_rheo.^2+delta_eta_volumefraction.^2);

    

    x(kk) = D(ii)*f(sigma);
    F(kk) = eta(kk)*(phi0-phi)^2;
    %delta_F(kk) = F(kk) .* (eta(kk).^(-2).*delta_eta_rheo.^2 + 4/(phi0-phi)^2*delta_phi^2 ).^(1/2);
end

% calculate F_hat from x
alpha=1;
xi = x.^(-1/alpha)-1;
logintersection = log(A/eta0)/(-delta-2);
mediator = cosh(width*(log(xi)-logintersection));
Hconst = exp(1/(2*width)*(-2-delta)*log(2)+(1/2)*log(A*eta0));
H_hat = Hconst * xi.^((delta-2)/2) .* (mediator).^((-2-delta)/(2*width));

if delta==-2
    H_hat = sqrt(A*eta0) * xi.^((delta-2)/2);
end

F_hat = 1./x.^(2/alpha) .* H_hat;
F_hat(x<1e-155)=eta0;

eta_hat = zeros(N,1);
for kk = 1:N
    phi = stressTable(kk,1);
    eta_hat(kk) = F_hat(kk)*(phi0-phi)^-2;
end 



end