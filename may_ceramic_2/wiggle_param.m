function wiggle_param(dataTable,paramsVector, modelHandle, paramNum)

%[eta0, phi0, delta, A, width, sigmastarParams,  b, phistarParams, Cphi0params];

myParamOptimal = paramsVector(paramNum);

deltaParam = myParamOptimal*0.0001;
paramRange = linspace(myParamOptimal-deltaParam,myParamOptimal+deltaParam,20);

SSR = @(yReduced) sum(get_residuals(dataTable, yReduced, modelHandle).^2); 
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
end
