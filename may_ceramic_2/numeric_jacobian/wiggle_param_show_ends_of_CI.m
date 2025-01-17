%function wiggle_param_with_refitting(dataTable,paramsVector, modelHandle, paramNum)

dataTable = may_ceramic_09_17;
load("01_12_optimal_params.mat")
%myModelHandle = @modelHandpickedAll; paramsVector = y_full_fmin_lsq;
myModelHandle = @modelSmoothFunctions; paramsVector = y_smooth_fmin_lsq;

paramNum=3;
myParamOptimal = paramsVector(paramNum);

%deltaParam = myParamOptimal*0.1;
deltaParam = 0.1;
paramRange = [myParamOptimal-deltaParam, myParamOptimal, myParamOptimal+deltaParam];

SSR = @(yReduced) sum(get_residuals(dataTable, yReduced, myModelHandle).^2); 
resnorm0 = SSR(paramsVector);
resnorm = zeros(size(paramRange));
epsilon = zeros(size(paramRange));
for ii = 1:length(paramRange)
    myParam = paramRange(ii);
    y_init = paramsVector;
    y_init(paramNum) = myParam;
    y = optimize_params_fix_one_param(dataTable,myModelHandle,y_init,paramNum);
    myResnorm = SSR(y);                                                                                                                                                                                                                                        

    epsilon(ii) = myParam-myParamOptimal;
    resnorm(ii) = myResnorm-resnorm0;

    show_F_vs_xc_x(dataTable,y,myModelHandle,'ShowInterpolatingFunction',true)
end

figure;
hold on;
plot(epsilon,resnorm,'-o','LineWidth',1)
ylabel('\Delta SSR')
xlabel('\Delta parameter')
%end
