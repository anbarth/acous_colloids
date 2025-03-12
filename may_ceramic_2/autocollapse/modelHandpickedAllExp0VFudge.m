function [x,F,delta_F,F_hat,eta,delta_eta,eta_hat] = modelHandpickedAllExp0VFudge(stressTable, y)

phi_list = unique(stressTable(:,1));
volt_list = [0,5,10,20,40,60,80];
numPhi = length(phi_list);

eta0 = y(1);
phi0 = y(2);
delta = y(3);
A = y(4);
width = y(5);
sigmastar = y(6);
D = y(7:7+numPhi-1);
phi_fudge = y(7+numPhi:end);

f = @(sigma) exp(-sigmastar./sigma);

N = size(stressTable,1);
x = zeros(N,1);
F = zeros(N,1);
delta_F = zeros(N,1);
eta = zeros(N,1);
delta_eta = zeros(N,1);

for kk = 1:N
    phi = stressTable(kk,1);
    my_fudge = phi_fudge(phi==phi_list);
    phi_fudged = phi+my_fudge;
    sigma = stressTable(kk,2);
    voltage = stressTable(kk,3);
    eta(kk) = stressTable(kk,4);        
    delta_eta(kk) = max(stressTable(kk,5),eta(kk)*0.05);

    ii = find(phi == phi_list);
    jj = find(voltage == volt_list);

    x(kk) = D(ii)*f(sigma);
    F(kk) = eta(kk)*(phi0-phi_fudged)^2;
    delta_F(kk) = F(kk) .* (eta(kk).^(-1).*delta_eta(kk));
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
    my_fudge = phi_fudge(phi==phi_list);
    phi_fudged = phi+my_fudge;
    eta_hat(kk) = F_hat(kk)*(phi0-phi_fudged)^-2;
end 



end