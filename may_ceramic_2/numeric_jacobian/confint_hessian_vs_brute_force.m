dataTable = may_ceramic_09_17;



%load("01_12_optimal_params.mat")
%myModelHandle = @modelHandpickedAll; paramsVector = y_full_fmin_lsq;
%myModelHandle = @modelSmoothFunctions; paramsVector = y_smooth_fmin_lsq;

%optimize_sigmastarV_03_19;
%myModelHandle = @modelHandpickedSigmastarV;paramsVector = y_lsq;
%myModelHandle = @modelHandpickedSigmastarV_logsigmastar; y_log=y_fmincon; y_log(6:12)=log(y_fmincon(6:12)); paramsVector = y_log;

optimize_C_jardy_03_19; dataTable = dataTable(dataTable(:,3)==0,:);
myModelHandle = @modelHandpickedAllExp0V; paramsVector = y_lsq_0V;
%myModelHandle = @modelHandpickedAllExp0V_expsigmastar; y_exp=y_lsq_0V; y_exp(6) = exp(y_lsq_0V(6)); paramsVector = y_exp;
%myModelHandle = @modelHandpickedAllExp0V_logsigmastar; y_log=y_lsq_0V; y_log(6) = log(y_lsq_0V(6)); paramsVector = y_log;
% NOTE that if you pick the logsigma* option, then you need to go down to optimize_params_fix_one_param_loggily
% and add 6 as an additional parameter. bc log(sigma*)<0. and this means we
% have to assume sigma*<1, which is... probably true.


paramNum = 3;

jacobian = numeric_jacobian(dataTable,paramsVector,myModelHandle);
%jacobian = numeric_jacobian_loggily(dataTable,paramsVector,myModelHandle,3);
%jacobian = numeric_jacobian_logsome(dataTable,paramsVector,myModelHandle,6,7,8,9,10,11,12);
hessian = transpose(jacobian)*jacobian;

% compute confidence intervals via hessian
variances = diag(pinv(hessian));
dof = size(jacobian,1)-size(jacobian,2); % dof = N-P
hessian_ci = sqrt(variances)*tinv(0.975,dof);

myParamOptimal = paramsVector(paramNum);
myHessianCI = hessian_ci(paramNum);
disp([myParamOptimal myHessianCI])
%disp([myParamOptimal-myHessianCI myParamOptimal myParamOptimal+myHessianCI])
%disp(exp([myParamOptimal-myHessianCI myParamOptimal myParamOptimal+myHessianCI]))
%disp([exp(log(myParamOptimal)-myHessianCI) myParamOptimal exp(log(myParamOptimal)+myHessianCI)])

%return

deltaParam = myHessianCI*1;
%deltaParam = 0.1;
paramRange = linspace(myParamOptimal-deltaParam,myParamOptimal+deltaParam,9);
%paramRange = linspace(myParamOptimal-deltaParam,myParamOptimal+0.9,9);


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
    %     show_cardy(dataTable,y,myModelHandle,'ShowInterpolatingFunction',true)
        show_F_vs_xc_x(dataTable,y,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',2,'ShowLines',true);  title(myParam)
       show_F_vs_x(dataTable,y,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',2,'ShowLines',true); xlim([1e-2 1.5])
     % show_F_vs_x(dataTable,y,myModelHandle,'ShowInterpolatingFunction',true,'ShowLines',true,'VoltRange',paramNum-5); xlim([1e-2 1.5])
       title(myParam)
    end

    hessian_resnorm(ii) = (1/2)*(y-paramsVector)*hessian*(y-paramsVector)';
    first=false;
end

figure;
hold on;
plot(paramRange,resnorm,'-o','LineWidth',1)
plot(paramRange,hessian_resnorm,'-o','LineWidth',1)
ylabel('\Delta SSR')
xlabel('parameter')
xline(myParamOptimal-myHessianCI)
xline(myParamOptimal+myHessianCI)
prettyplot

% figure;
% hold on;
% plot(epsilon,hessian_resnorm,'-o','LineWidth',1)
% ylabel('\Delta SSR from Hessian')
% xlabel('\Delta parameter')
%xline(-myHessianCI)
%xline(myHessianCI)

%end
