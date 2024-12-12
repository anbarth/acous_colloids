function residuals = getResiduals(stressTable, paramsVector, phi_list, volt_list)

alpha=1;

if nargin < 3
    phi_list = unique(stressTable(:,1));
end
if nargin < 4
    volt_list = unique(stressTable(:,3));
end


%[F_hat,F,delta_F] = get_F_hat(stressTable, paramsVector, phi_list, volt_list);
%residuals = (F_hat - F) ./ delta_F;

[eta_hat, eta, delta_eta] = get_eta_hat(stressTable, paramsVector, phi_list, volt_list);
residuals = (eta_hat - eta) ./ delta_eta;

% infinite penalty for imaginary residuals
residuals(imag(residuals)~=0)=Inf;


end