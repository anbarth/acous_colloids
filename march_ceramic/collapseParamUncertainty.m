function paramUncertainty = collapseParamUncertainty(paramsVector, stressTable)

N = size(stressTable,1); % num data points
P = length(paramsVector); % num parameters

sse = collapseSSE(paramsVector,stressTable);
J = collapseJacobian(paramsVector,stressTable);

big_ol_matrix = inv(transpose(J)*J)*sse/(N-P);

parameter_variance = diag(big_ol_matrix);
parameter_std_err = sqrt(parameter_variance);
paramUncertainty = parameter_std_err*tinv(0.975,N-P);

end