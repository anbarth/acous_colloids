function [x,F,delta_F,F_hat,eta,delta_eta,eta_hat] = modelSmoothFunctions(stressTable, yReduced)

% y = [eta0, phi0, delta, A, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]
[eta0, phi0, delta, A, width, sigmastarParams, alpha, beta, q0params, q1params] = unzipReducedParams(yReduced);

f = @(sigma,star) sigma./(star+sigma);


N = size(stressTable,1);
x = zeros(N,1);
F = zeros(N,1);
delta_F = zeros(N,1);
eta = zeros(N,1);
delta_eta = zeros(N,1);

for kk = 1:N
    phi = stressTable(kk,1);
    dphi = phi0-phi;
    sigma = stressTable(kk,2);
    V = stressTable(kk,3);
    eta(kk) = stressTable(kk,4);        
    delta_eta_rheo = max(stressTable(kk,5),eta(kk)*0.05);
    delta_phi = 0.02;
    delta_eta_volumefraction = eta(kk)*2*(phi0-phi)^(-1)*delta_phi;
    delta_eta(kk) = sqrt(delta_eta_rheo.^2+delta_eta_volumefraction.^2);

    sigmastar = sigmastarParams(1)*V^2 + sigmastarParams(2)*V + sigmastarParams(3);
    q0 = q0params(1)*V + q0params(2);
    q1 = q1params(1)*V + q1params(2);
    D = 1/( (q0*dphi)^alpha + (q1*dphi)^(alpha+beta) );

    x(kk) = D*f(sigma,sigmastar);
    F(kk) = eta(kk)*(phi0-phi)^2;
    delta_F(kk) = F(kk) .* (eta(kk).^(-2).*delta_eta_rheo.^2 + 4/(phi0-phi)^2*delta_phi^2 ).^(1/2);
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

eta_hat = zeros(N,1);
for kk = 1:N
    phi = stressTable(kk,1);
    eta_hat(kk) = F_hat(kk)*(phi0-phi)^-2;
end 

end