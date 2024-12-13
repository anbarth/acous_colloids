function residuals = get_residuals(stressTable, paramsVector, modelHandle)

[x,~,~,~,eta,delta_eta,eta_hat] = modelHandle(stressTable, paramsVector);
residuals = (eta_hat - eta) ./ delta_eta;

%[~,F,delta_F,F_hat,~,~,~] = modelHandle(stressTable, paramsVector);
%residuals = (F_hat - F) ./ delta_F;

% infinite penalty for imaginary residuals
residuals(imag(residuals)~=0)=Inf;
residuals(imag(x)~=0)=Inf;

end