dataTable = may_ceramic_09_17;
load("01_12_optimal_params.mat")
%myModelHandle = @modelHandpickedAll; myParams = y_full_fmin_lsq;
myModelHandle = @modelSmoothFunctions; myParams = y_smooth_fmin_lsq;

jacobian = numeric_jacobian(dataTable,myParams,myModelHandle);
hessian = transpose(jacobian)*jacobian;

% compute confidence intervals?
variances = diag(pinv(hessian));
%variances = diag(hessian);
dof = size(jacobian,1)-size(jacobian,2); % dof = N-P
errs = sqrt(variances)*tinv(0.975,dof);
%disp([myParams', errs])

paramNum = 5;
disp([myParams(paramNum), errs(paramNum)])
myParamsAlt = myParams;
myParamsAlt(paramNum) = myParams(paramNum)+errs(paramNum);
%myParamsAlt(paramNum) = myParams(paramNum)+0.02;
%show_F_vs_xc_x(dataTable,myParams,myModelHandle,'ShowInterpolatingFunction',true,'VoltRange',1,'ColorBy',2,'ShowErrorBars',true)
%show_F_vs_xc_x(dataTable,myParamsAlt,myModelHandle,'ShowInterpolatingFunction',true,'VoltRange',1,'ColorBy',2,'ShowErrorBars',true)

costfxn = @(y) sum(get_residuals(dataTable,y,myModelHandle).^2);
disp(costfxn(myParams))
disp(costfxn(myParamsAlt))