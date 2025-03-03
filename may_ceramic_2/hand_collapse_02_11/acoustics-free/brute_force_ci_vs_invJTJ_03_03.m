%function wiggle_param_with_refitting(dataTable,paramsVector, modelHandle, paramNum)

%optimize_C_jardy_02_11;
%y_optimal = y_lsq_0V;
y_optimal = y_fmincon_0V;
myModelHandle = @modelHandpickedAllExp0V;

paramNum=3;

myParamOptimal = y_optimal(paramNum);

%deltaParam = myParamOptimal*0.5;
deltaParam = 0.08;
paramRange = linspace(myParamOptimal-deltaParam,myParamOptimal+deltaParam,13);
%paramRange = linspace(myParamOptimal-deltaParam,1,7);
%paramRange = logspace(-20,-1,9);

% inverse hessian
jacobian = numeric_jacobian(acoustics_free_data,y_optimal,myModelHandle);
hessian = transpose(jacobian)*jacobian;

SSR = @(y) sum(get_residuals(acoustics_free_data, y, myModelHandle).^2); 
resnorm0 = SSR(y_optimal);
deltaSSR_BF = zeros(size(paramRange));
deltaSSR_JTJ = zeros(size(paramRange));
epsilon = zeros(size(paramRange));
%for ii=1
for ii = 1:length(paramRange)
    myParam = paramRange(ii);
    y_init = y_optimal;
    y_init(paramNum) = myParam;
    y = optimize_params_fix_one_param_0V_02_11(acoustics_free_data,myModelHandle,y_init,paramNum);
    myResnorm = SSR(y);                                                                                                                                                                                                                                        

    epsilon(ii) = myParam-myParamOptimal;
    deltaSSR_BF(ii) = myResnorm-resnorm0;
    deltaSSR_JTJ(ii) = (1/2)*(y-y_optimal)*hessian*(y-y_optimal)';
    

end

figure;
hold on;
ax1=gca;ax1.XScale='log';
plot(paramRange,deltaSSR_BF,'-o','LineWidth',1)
plot(paramRange,deltaSSR_JTJ,'-o','LineWidth',1)
%legend('brute force','J^TJ')
ylabel('\Delta SSR')
%xlabel('\Delta parameter')
xlabel('parameter')
%yline(1)
%ylim([0 10])
title(paramNum)





% compute confidence intervals?
variances = diag(pinv(hessian));
dof = size(jacobian,1)-size(jacobian,2); % dof = N-P
%confInts = sqrt(variances)*tinv(0.975,dof);
confInts = real(sqrt(variances)*tinv(0.975,dof));
%xline(myParamOptimal-confInts(paramNum))
%xline(myParamOptimal+confInts(paramNum))


