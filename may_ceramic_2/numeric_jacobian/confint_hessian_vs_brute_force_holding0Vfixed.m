dataTable = may_ceramic_09_17;

optimize_sigmastarV_hold_0V_fixed_03_19;
%optimize_sigmastarV_03_19;
paramsVector = y_fmincon;
myModelHandle = @modelHandpickedSigmastarV;


paramNum = 3;

jacobian = numeric_jacobian(dataTable,paramsVector,myModelHandle);
%jacobian = jacobian(:,7:12);
%jacobian = numeric_jacobian_loggily(dataTable,paramsVector,myModelHandle,3);
hessian = transpose(jacobian)*jacobian;

% compute confidence intervals via hessian
variances = diag(pinv(hessian));
dof = size(jacobian,1)-size(jacobian,2); % dof = N-P
hessian_ci = sqrt(variances)*tinv(0.975,dof);

myParamOptimal = paramsVector(paramNum);
myHessianCI = hessian_ci(paramNum);
%myHessianCI = hessian_ci(paramNum-6);
disp([myParamOptimal myHessianCI])

return
myParamsAlt = paramsVector;
myParamsAlt(paramNum) = paramsVector(paramNum)+hessian_ci(paramNum);

%show_F_vs_xc_x(dataTable,myParams,myModelHandle,'ShowInterpolatingFunction',true,'VoltRange',1,'ColorBy',2,'ShowErrorBars',true)
%show_F_vs_xc_x(dataTable,myParamsAlt,myModelHandle,'ShowInterpolatingFunction',true,'VoltRange',1,'ColorBy',2,'ShowErrorBars',true)


deltaParam = myHessianCI*1;
%deltaParam = 0.5;
paramRange = linspace(myParamOptimal-deltaParam,myParamOptimal+deltaParam,9);
%paramRange = linspace(myParamOptimal-deltaParam,myParamOptimal,9);

SSR = @(y) sum(get_residuals(dataTable, y, myModelHandle).^2); 
resnorm0 = SSR(paramsVector);
resnorm = zeros(size(paramRange));
epsilon = zeros(size(paramRange));

hessian_resnorm = zeros(size(paramRange));
first=true;
for ii = 1:length(paramRange)
    myParam = paramRange(ii);
    y_init = paramsVector;
    y_init(paramNum) = myParam;

    % avoid crashing the optimizer
    [~,~,~,F_hat,~,~,~] = myModelHandle(dataTable,y_init);
    if any(imag(F_hat)~=0)
        epsilon(ii)=NaN;
        resnorm(ii)=NaN;
        continue
    end

    y = optimize_params_fix_one_param_loggily(dataTable,myModelHandle,y_init,paramNum,3);
    myResnorm = SSR(y);                                                                                                                                                                                                                                        

    epsilon(ii) = myParam-myParamOptimal;
    resnorm(ii) = myResnorm-resnorm0;

    if myParam==myParamOptimal || first || ii==length(paramRange)
      % show_F_vs_x(dataTable,y,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',2,'ShowLines',true); xlim([1e-2 1.5])
       show_F_vs_x(dataTable,y,myModelHandle,'ShowInterpolatingFunction',true,'ShowLines',true,'VoltRange',paramNum-5); xlim([1e-2 1.5])
       title(myParam-myParamOptimal)
    end

    hessian_resnorm(ii) = (1/2)*(y-paramsVector)*hessian*(y-paramsVector)';
    first=false;
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
