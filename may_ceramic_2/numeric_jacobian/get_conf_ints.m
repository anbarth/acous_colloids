%function [confInts_upper, confInts_lower] = get_conf_ints(dataTable,myParams,myModelHandle,varargin)
function ci = get_conf_ints(dataTable,myParams,myModelHandle)


jacobian = numeric_jacobian(dataTable,myParams,myModelHandle);
%jacobian = numeric_jacobian_logsome(dataTable,myParams,myModelHandle,varargin{:});
hessian = transpose(jacobian)*jacobian;
variances = diag(pinv(hessian));
dof = size(jacobian,1)-size(jacobian,2); % dof = N-P
ci = sqrt(variances)*tinv(0.975,dof);
%confInts_upper = ci;
%confInts_lower = ci;

% for ii=1:length(varargin)
%     paramNum = varargin{ii};
%     param = myParams(paramNum);
%     lowerBound = exp(log(param)-ci(paramNum));
%     upperBound = exp(log(param)+ci(paramNum));
%     confInts_lower(paramNum) = param - lowerBound;
%     confInts_upper(paramNum) = upperBound - param;
% end

end