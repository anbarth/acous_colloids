%function wiggle_param(dataTable,paramsVector, myModelHandle, paramNum)

dataTable = may_ceramic_09_17;
load("01_12_optimal_params.mat")
%myModelHandle = @modelHandpickedAll; paramsVector = y_full_fmin_lsq;
myModelHandle = @modelSmoothFunctions; paramsVector = y_smooth_fmin_lsq;

paramNum=5;

myParamOptimal = paramsVector(paramNum);

deltaParam = myParamOptimal*0.1;
paramRange = linspace(myParamOptimal-deltaParam,myParamOptimal+deltaParam,20);

SSR = @(yReduced) sum(get_residuals(dataTable, yReduced, myModelHandle).^2); 
resnorm0 = SSR(paramsVector);
resnorm = zeros(size(paramRange));
epsilon = zeros(size(paramRange));
for ii = 1:length(paramRange)
    myParam = paramRange(ii);
    y = paramsVector;
    y(paramNum) = myParam;
    myResnorm = SSR(y);                                                                                                                                                                                                                                        

    epsilon(ii) = myParam-myParamOptimal;
    resnorm(ii) = myResnorm-resnorm0;
end

figure;
hold on;
plot(epsilon,resnorm,'-o','LineWidth',1)
ylabel('\Delta SSR')
xlabel('\Delta parameter')
%end
