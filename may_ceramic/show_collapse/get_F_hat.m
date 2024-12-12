function [F_hat,F,delta_F] = get_F_hat(stressTable, paramsVector, phi_list, volt_list)

alpha=1;

if nargin < 3
    phi_list = unique(stressTable(:,1));
end
if nargin < 4
    volt_list = unique(stressTable(:,3));
end

% get x
[x,F,delta_F] = calc_x_F(stressTable, paramsVector);

% calculate F_hat from x
[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(paramsVector,length(phi_list));
xi = x.^(-1/alpha)-1;
logintersection = log(A/eta0)/(-delta-2);
mediator = cosh(width*(log(xi)-logintersection));
Hconst = exp(1/(2*width)*(-2-delta)*log(2)+(1/2)*log(A*eta0));
H_hat = Hconst * xi.^((delta-2)/2) .* (mediator).^((-2-delta)/(2*width));

if delta==-2
    H_hat = sqrt(A*eta0) * xi.^((delta-2)/2);
end

F_hat = 1./x.^(2/alpha) .* H_hat;

end