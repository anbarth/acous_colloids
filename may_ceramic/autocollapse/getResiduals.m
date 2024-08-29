function residuals = getResiduals(stressTable, paramsVector, phi_list, volt_list)

if nargin < 3
    phi_list = unique(stressTable(:,1));
end
if nargin < 4
    volt_list = unique(stressTable(:,3));
end

[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(paramsVector,length(phi_list));

f = @(sigma,jj) exp(-sigmastar(jj)./sigma);

x_all = zeros(size(stressTable,1),1);
F_all = zeros(size(stressTable,1),1);
F_uncert_all = zeros(size(stressTable,1),1);
%H_all = zeros(size(stressTable,1),1);

for kk=1:size(stressTable,1)
    phi = stressTable(kk,1);
    sigma = stressTable(kk,2);
    voltage = stressTable(kk,3);
    eta = stressTable(kk,4);
    eta_uncert = stressTable(kk,5);
    phi_uncert = 0.01; % hardcoded yuck
    %ii = find(phi == phi_list);
    jj = find(voltage == volt_list);
    my_phi_fudge = phi_fudge(phi==phi_list);


    x = C(phi == phi_list,voltage == volt_list)*f(sigma,jj);
    F = eta * (phi0-(phi+my_phi_fudge))^2;
    %F_uncert = eta_uncert * (phi0-(phi+my_phi_fudge))^2;
    F_uncert = F*( (eta_uncert/eta)^2 + (2*phi_uncert/(phi0-(phi+my_phi_fudge)))^2  )^(1/2);

    x_all(kk) = x;
    F_all(kk) = F;
    F_uncert_all(kk) = F_uncert;
    %H_all(kk) = H;


end

xi = 1./x_all-1;
logintersection = log(A/eta0)/(-delta-2);
mediator = cosh(width*(log(xi)-logintersection));
Hconst = exp(1/(2*width)*(-2-delta)*log(2)+(1/2)*log(A*eta0));
Hhat = Hconst * xi.^((delta-2)/2) .* (mediator).^((-2-delta)/(2*width));

if delta==-2
    Hhat = sqrt(A*eta0) * xi.^((delta-2)/2);
end

Fhat = 1./x_all.^2 .* Hhat;

residuals = (Fhat - F_all) ./ (F_uncert_all);
%residuals = (Fhat - F_all) ./ (F_all);


end