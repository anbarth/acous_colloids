%function wiggle_param_with_refitting(dataTable,paramsVector, modelHandle, paramNum)

%optimize_C_jardy_02_11;
paramsVector = y_lsq_0V;
myModelHandle = @modelHandpickedAllExp0V;

paramNum=3;


myParamOptimal = paramsVector(paramNum);

deltaParam = myParamOptimal*0.25;
paramRange = linspace(myParamOptimal-deltaParam,myParamOptimal+deltaParam,7);

%paramRange = linspace(myParamOptimal-deltaParam,1,7);

SSR = @(y) sum(get_residuals(acoustics_free_data, y, myModelHandle).^2); 
resnorm0 = SSR(paramsVector);
resnorm = zeros(size(paramRange));
epsilon = zeros(size(paramRange));
for ii = 1:length(paramRange)
    myParam = paramRange(ii);
    y_init = paramsVector;
    y_init(paramNum) = myParam;
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
