stressTable=may_ceramic_09_17;
paramsVector=y_optimal;

    phi_list = unique(stressTable(:,1));

    volt_list = unique(stressTable(:,3));

% get x, F
[x_all,F_all,F_uncert_all] = calc_x_F(stressTable, paramsVector);
H_all = F_all .* x_all.^2;
H_uncert_all = F_uncert_all.*x_all.^2;

% calculate Fhat from x
[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(paramsVector,length(phi_list));
xi = 1./x_all-1;
logintersection = log(A/eta0)/(-delta-2);
mediator = cosh(width*(log(xi)-logintersection));
Hconst = exp(1/(2*width)*(-2-delta)*log(2)+(1/2)*log(A*eta0));
Hhat = Hconst * xi.^((delta-2)/2) .* (mediator).^((-2-delta)/(2*width));

if delta==-2
    Hhat = sqrt(A*eta0) * xi.^((delta-2)/2);
end

Fhat = 1./x_all.^2 .* Hhat;

% calculate residuals
residuals = (Fhat - F_all) ./ (F_uncert_all);
%residuals = (Hhat - H_all) ./ (H_uncert_all);

