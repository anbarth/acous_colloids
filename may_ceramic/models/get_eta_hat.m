function eta_hat= get_eta_hat(stressTable, paramsVector, modelHandle)

[~,~,~,~,~,~,eta_hat] = modelHandle(stressTable, paramsVector);

end