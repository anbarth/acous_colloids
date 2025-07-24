function [confInts_upper, confInts_lower] = get_conf_ints_loggily(dataTable,myParams,myModelHandle,varargin)
%function ci = get_conf_ints(dataTable,myParams,myModelHandle)


jacobian = numeric_jacobian_loggily(dataTable,myParams,myModelHandle);
%jacobian = numeric_jacobian_logsome(dataTable,myParams,myModelHandle,varargin{:});
hessian = transpose(jacobian)*jacobian;
tol = max(size(hessian))*eps(norm(hessian));
variances = diag(pinv(hessian,tol));
dof = size(jacobian,1)-size(jacobian,2); % dof = N-P
ci = sqrt(variances)*tinv(0.975,dof);
confInts_upper = ci;
confInts_lower = ci;

for paramNum=1:length(ci)
    param = myParams(paramNum);
    lowerBound = exp(log(param)-ci(paramNum));
    upperBound = exp(log(param)+ci(paramNum));
    confInts_lower(paramNum) = param - lowerBound;
    confInts_upper(paramNum) = upperBound - param;
end

end