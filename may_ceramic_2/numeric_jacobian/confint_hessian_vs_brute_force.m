dataTable = may_ceramic_09_17;
%load("01_12_optimal_params.mat")
%myModelHandle = @modelHandpickedAll; paramsVector = y_full_fmin_lsq;
%myModelHandle = @modelSmoothFunctions; paramsVector = y_smooth_fmin_lsq;

%optimize_sigmastarV_03_19;
%paramsVector = y_fmincon;
%myModelHandle = @modelHandpickedSigmastarV;

optimize_C_jardy_03_19;
paramsVector = y_lsq_0V;
myModelHandle = @modelHandpickedAllExp0V;
dataTable = dataTable(dataTable(:,3)==0,:);

paramNum = 3;

jacobian = numeric_jacobian(dataTable,paramsVector,myModelHandle);
hessian = transpose(jacobian)*jacobian;

% compute confidence intervals via hessian
variances = diag(pinv(hessian));
dof = size(jacobian,1)-size(jacobian,2); % dof = N-P
hessian_ci = sqrt(variances)*tinv(0.975,dof);

myParamOptimal = paramsVector(paramNum);
myHessianCI = hessian_ci(paramNum);
disp([myParamOptimal myHessianCI])
myParamsAlt = paramsVector;
myParamsAlt(paramNum) = paramsVector(paramNum)+hessian_ci(paramNum);

%show_F_vs_xc_x(dataTable,myParams,myModelHandle,'ShowInterpolatingFunction',true,'VoltRange',1,'ColorBy',2,'ShowErrorBars',true)
%show_F_vs_xc_x(dataTable,myParamsAlt,myModelHandle,'ShowInterpolatingFunction',true,'VoltRange',1,'ColorBy',2,'ShowErrorBars',true)

deltaParam = myParamOptimal*0.8;
%deltaParam = myHessianCI;
%deltaParam = 0.5;
paramRange = linspace(myParamOptimal-deltaParam,myParamOptimal+deltaParam,9);

SSR = @(y) sum(get_residuals(dataTable, y, myModelHandle).^2); 
resnorm0 = SSR(paramsVector);
resnorm = zeros(size(paramRange));
epsilon = zeros(size(paramRange));

hessian_resnorm = zeros(size(paramRange));
for ii = 1:length(paramRange)
    myParam = paramRange(ii);
    y_init = paramsVector;
    y_init(paramNum) = myParam;
    y = optimize_params_fix_one_param_loggily(dataTable,myModelHandle,y_init,paramNum);
    myResnorm = SSR(y);                                                                                                                                                                                                                                        

    epsilon(ii) = myParam-myParamOptimal;
    resnorm(ii) = myResnorm-resnorm0;

    if myParam==myParamOptimal || ii==1 || ii==length(paramRange)
       show_F_vs_x(dataTable,y,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',2,'ShowLines',true); xlim([1e-2 1.5])
       title(myParam-myParamOptimal)
    end

    hessian_resnorm(ii) = (1/2)*(y-paramsVector)*hessian*(y-paramsVector)';
    
end

figure;
hold on;
plot(epsilon,resnorm,'-o','LineWidth',1)
plot(epsilon,hessian_resnorm,'-o','LineWidth',1)
ylabel('\Delta SSR')
xlabel('\Delta parameter')
xline(-myHessianCI)
xline(myHessianCI)

% figure;
% hold on;
% plot(epsilon,hessian_resnorm,'-o','LineWidth',1)
% ylabel('\Delta SSR from Hessian')
% xlabel('\Delta parameter')
%xline(-myHessianCI)
%xline(myHessianCI)

%end
