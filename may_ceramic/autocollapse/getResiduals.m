function residuals = getResiduals(stressTable, paramsVector, phi_list, volt_list)

alpha=1;

if nargin < 3
    phi_list = unique(stressTable(:,1));
end
if nargin < 4
    volt_list = unique(stressTable(:,3));
end

% get x, F
[x_all,F_all,F_uncert_all] = calc_x_F(stressTable, paramsVector);
H_all = F_all .* x_all.^(2/alpha);
H_uncert_all = F_uncert_all.*x_all.^(2/alpha);

% calculate Fhat from x
[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(paramsVector,length(phi_list));
xi = x_all.^(-1/alpha)-1;
logintersection = log(A/eta0)/(-delta-2);
mediator = cosh(width*(log(xi)-logintersection));
Hconst = exp(1/(2*width)*(-2-delta)*log(2)+(1/2)*log(A*eta0));
Hhat = Hconst * xi.^((delta-2)/2) .* (mediator).^((-2-delta)/(2*width));

if delta==-2
    Hhat = sqrt(A*eta0) * xi.^((delta-2)/2);
end

Fhat = 1./x_all.^(2/alpha) .* Hhat;
%Fhat = 1./x_all.^(2/3) .* Hhat;

% calculate residuals
residuals = (Fhat - F_all) ./ (F_uncert_all);
%residuals = (Hhat - H_all) ./ (H_uncert_all);

% infinite penalty for imaginary residuals
residuals(imag(residuals)~=0)=Inf;


end