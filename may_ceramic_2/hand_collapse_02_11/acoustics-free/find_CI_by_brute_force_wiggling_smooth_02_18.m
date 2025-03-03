%function wiggle_param_with_refitting(dataTable,paramsVector, modelHandle, paramNum)

%optimize_logistic_C_02_18;
paramsVector = y_lsq_smooth_0V;
myModelHandle = @modelLogisticCExp0V;

paramNum=7;


myParamOptimal = paramsVector(paramNum);

deltaParam = myParamOptimal*0.5;
paramRange = linspace(myParamOptimal-deltaParam,myParamOptimal+deltaParam,7);


SSR = @(y) sum(get_residuals(acoustics_free_data, y, myModelHandle).^2); 
resnorm0 = SSR(paramsVector);
resnorm = zeros(size(paramRange));
epsilon = zeros(size(paramRange));
%for ii=1
for ii = 1:length(paramRange)
    myParam = paramRange(ii);
    y_init = paramsVector;
    y_init(paramNum) = myParam;
    %show_F_vs_x(acoustics_free_data,y_init,@modelLogisticCExp0V,'ColorBy',2,'ShowInterpolatingFunction',true)
    y = optimize_params_fix_one_param_0V_02_11(acoustics_free_data,myModelHandle,y_init,paramNum);
    myResnorm = SSR(y);                                                                                                                                                                                                                                        

    epsilon(ii) = myParam-myParamOptimal;
    resnorm(ii) = myResnorm-resnorm0;
    

end

figure;
hold on;
plot(paramRange,resnorm,'-o','LineWidth',1)
ylabel('\Delta SSR')
%xlabel('\Delta parameter')
xlabel('parameter')
yline(1)
ylim([0 10])
title(paramNum)
%end
