function confInts = get_conf_ints(dataTable,myParams,myModelHandle)

%jacobian = numeric_jacobian_exp(dataTable,myParams,myModelHandle);
%jacobian = numeric_jacobian_loggily(dataTable,myParams,myModelHandle);
jacobian = numeric_jacobian(dataTable,myParams,myModelHandle);
hessian = transpose(jacobian)*jacobian;
variances = diag(pinv(hessian));
dof = size(jacobian,1)-size(jacobian,2); % dof = N-P
confInts = sqrt(variances)*tinv(0.975,dof);

end