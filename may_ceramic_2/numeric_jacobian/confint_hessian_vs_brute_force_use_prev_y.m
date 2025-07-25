dataTable = may_ceramic_09_17;

optimize_C_jardy_03_19; dataTable = dataTable(dataTable(:,3)==0,:);
myModelHandle = @modelHandpickedAllExp0V; paramsVector = y_lsq_0V;

paramNum = 6;

jacobian = numeric_jacobian(dataTable,paramsVector,myModelHandle);
hessian = transpose(jacobian)*jacobian;

% compute confidence intervals via hessian
variances = diag(pinv(hessian));
dof = size(jacobian,1)-size(jacobian,2); % dof = N-P
hessian_ci = sqrt(variances)*tinv(0.975,dof);

myParamOptimal = paramsVector(paramNum);
myHessianCI = hessian_ci(paramNum);
disp([myParamOptimal myHessianCI])

%return

%deltaParam = myHessianCI*1;
deltaParam = 0.9;
paramRange = linspace(myParamOptimal,myParamOptimal+deltaParam,9);
%paramRange = linspace(myParamOptimal-deltaParam,myParamOptimal+0.9,9);


SSR = @(y) sum(get_residuals(dataTable, y, myModelHandle).^2); 
resnorm0 = SSR(paramsVector);
resnorm = zeros(size(paramRange));
epsilon = zeros(size(paramRange));

hessian_resnorm = zeros(size(paramRange));
first=true;
y_init = paramsVector;
for ii = 1:length(paramRange)
    myParam = paramRange(ii);
    y_init(paramNum) = myParam;

    % avoid crashing the optimizer
    [~,~,~,F_hat,~,~,~] = myModelHandle(dataTable,y_init);
    if any(imag(F_hat)~=0)
        epsilon(ii)=NaN;
        resnorm(ii)=NaN;
        continue
    end

    y = optimize_params_fix_one_param_loggily(dataTable,myModelHandle,y_init,paramNum,3);
    y_init = y;
    myResnorm = SSR(y);                                                                                                                                                                                                                                        

    epsilon(ii) = myParam-myParamOptimal;
    resnorm(ii) = myResnorm-resnorm0;

    if myParam==myParamOptimal || ii==length(paramRange)
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

% figure;
% hold on;
% plot(epsilon,hessian_resnorm,'-o','LineWidth',1)
% ylabel('\Delta SSR from Hessian')
% xlabel('\Delta parameter')
%xline(-myHessianCI)
%xline(myHessianCI)

%end
