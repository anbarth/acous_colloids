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


SSR = @(y) sum(get_residuals(dataTable, y, myModelHandle).^2); 
resnorm0 = SSR(paramsVector);
deltaSSRequals5 = @(paramValue) SSR_after_changing_param(dataTable,paramsVector,myModelHandle,paramNum,paramValue)-resnorm0-5;

%ci_left = fzero(deltaSSRequals5,0.02);
%ci_right = fzero(deltaSSRequals5,0.29);
%return

ci_left = 0.0201;
ci_right = 0.2871;



first=true;
paramRange = linspace(ci_left,ci_right,7);
paramRange = [paramRange, myParamOptimal];
paramRange = sort(paramRange);
resnorm = zeros(size(paramRange));
hessian_resnorm = zeros(size(paramRange));
epsilon = zeros(size(paramRange));

for ii = 1:length(paramRange)
    myParam = paramRange(ii);
    
    [myResnorm,y] = SSR_after_changing_param(dataTable,paramsVector,myModelHandle,paramNum,myParam);                                                                                                                                                                                                                                        

    epsilon(ii) = myParam-myParamOptimal;
    resnorm(ii) = myResnorm-resnorm0;
    hessian_resnorm(ii) = (1/2)*(y-paramsVector)*hessian*(y-paramsVector)';

    if myParam==myParamOptimal || first || ii==length(paramRange)
       show_F_vs_x(dataTable,y,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',2,'ShowLines',true); xlim([1e-2 1.5]);  title(myParam)
       show_F_vs_xc_x(dataTable,y,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',2,'ShowLines',true);  title(myParam)
      % show_F_vs_x(dataTable,y,myModelHandle,'ShowInterpolatingFunction',true,'ShowLines',true,'VoltRange',paramNum-5); xlim([1e-2 1.5])
    %   title(myParam-myParamOptimal)
    end

    first=false;
end

%%
figure;
hold on;
plot(paramRange,resnorm,'-o','LineWidth',1)
plot(paramRange,hessian_resnorm,'-o','LineWidth',1)

ylabel('\Delta SSR')
xlabel('parameter')
xline(ci_left,'b-'); xline(ci_right,'b-');
xline(myParamOptimal-myHessianCI); xline(myParamOptimal+myHessianCI);
prettyplot