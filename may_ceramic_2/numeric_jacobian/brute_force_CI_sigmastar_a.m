dataTable = may_ceramic_09_17;
optimize_sigmastarV_03_19;

myModelHandle = @modelHandpickedSigmastarV; paramsVector = y_fmincon;

ci_left_6 = 0.0201; ci_right_6 = 0.1601;
ci_left_7 = 0.0202; ci_right_7 = 0.1786;
ci_left_8 = 0.0245; ci_right_8 = 0.2233;
ci_left_9 = 0.0347; ci_right_9 = 0.3323;
ci_left_10 = 0.0800; ci_right_10 = 0.6558;
ci_left_11 = 0.1292; ci_right_11 = 1.3622;
ci_left_12 = 0.2133; ci_right_12 = 2.1913;

paramNum = 6; ci_left = ci_left_6; ci_right = ci_right_6;
%paramNum = 7; ci_left = ci_left_7; ci_right = ci_right_7;
%paramNum = 8; ci_left = ci_left_8; ci_right = ci_right_8;
%paramNum = 9; ci_left = ci_left_9; ci_right = ci_right_9;
%paramNum = 10; ci_left = ci_left_10; ci_right = ci_right_10;
%paramNum = 11; ci_left = ci_left_11; ci_right = ci_right_11;
%paramNum = 12; ci_left = ci_left_12; ci_right = ci_right_12;

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

%ci_left = fzero(deltaSSRequals5,0.2);
%ci_right = fzero(deltaSSRequals5,2);
%return




first=true;
paramRange = linspace(ci_left,ci_right,7);
paramRange = [paramRange, myParamOptimal];
paramRange = sort(paramRange);
resnorm = zeros(size(paramRange));
hessian_resnorm = zeros(size(paramRange));
epsilon = zeros(size(paramRange));

volt_list = [0 5 10 20 40 60 80];
U = acoustic_energy_density(volt_list);
CSS=(50/19)^3;

for ii = 1:length(paramRange)
    myParam = paramRange(ii);
    
    [myResnorm,y] = SSR_after_changing_param(dataTable,paramsVector,myModelHandle,paramNum,myParam);                                                                                                                                                                                                                                        

    epsilon(ii) = myParam-myParamOptimal;
    resnorm(ii) = myResnorm-resnorm0;
    hessian_resnorm(ii) = (1/2)*(y-paramsVector)*hessian*(y-paramsVector)';

    if myParam==myParamOptimal || first || ii==length(paramRange)
       show_F_vs_x(dataTable,y,myModelHandle,'ShowInterpolatingFunction',true); xlim([1e-2 1.5]);  title(myParam); prettyplot
       show_F_vs_xc_x(dataTable,y,myModelHandle,'ShowInterpolatingFunction',true);  title(myParam); prettyplot
       figure;hold on;makeAxesLogLog;plot(U,CSS*(y(6:12)-y(6)),'ko');plot(U,U,'k--');prettyplot;title(myParam);xlabel('U_a (Pa)');ylabel('\sigma^*_a (Pa)')
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
yline(5,'b-');
xline(myParamOptimal-myHessianCI); xline(myParamOptimal+myHessianCI);
prettyplot