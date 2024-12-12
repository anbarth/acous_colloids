function residuals = get_residuals(stressTable, paramsVector, modelHandle)

[~,~,~,~,eta,delta_eta,eta_hat] = modelHandle(stressTable, paramsVector);
residuals = (eta_hat - eta) ./ delta_eta;

% infinite penalty for imaginary residuals
residuals(imag(residuals)~=0)=Inf;

end