function wiggle_param_reduced(dataTable,yReduced_optimal,paramNum)

%[eta0, phi0, delta, A, width, sigmastarParams,  b, phistarParams, Cphi0params];

myParamOptimal = yReduced_optimal(paramNum);
phi_list = unique(dataTable(:,1));

deltaParam = 0.0001;
paramRange = linspace(myParamOptimal-deltaParam,myParamOptimal+deltaParam,20);

SSR = @(yReduced) sum(getResiduals(dataTable, reducedParamsToFullParams(yReduced,phi_list)).^2); 
resnorm0 = SSR(yReduced_optimal);
resnorm = zeros(size(paramRange));
epsilon = zeros(size(paramRange));
for ii = 1:length(paramRange)
    myParam = paramRange(ii);
    y = yReduced_optimal;
    y(paramNum) = myParam;
    myResnorm = SSR(y);                                                                                                                                                                                                                                        

    epsilon(ii) = myParam-myParamOptimal;
    resnorm(ii) = myResnorm-resnorm0;
end

figure;
hold on;
plot(epsilon,resnorm,'-o','LineWidth',1)
end
