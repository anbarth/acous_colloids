function uncertainty_delta_estimate_2(dataTable,y_optimal,paramNum)

%dataTable = may_ceramic_06_25;


%load("y_optimal_lsqnonlin_08_26.mat")
%[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13);

% epsilon = 0.05;
% [y_init,resnorm_init] = setDeltaResNorm(dataTable,y_optimal,delta);
% [y_minus,resnorm_minus] = setDeltaResNorm(dataTable,y_optimal,delta-epsilon);
% [y_plus,resnorm_plus] = setDeltaResNorm(dataTable,y_optimal,delta+epsilon);
% disp([resnorm_init resnorm_plus resnorm_minus])

myParamOptimal = y_optimal(paramNum);

deltaParam = 0.05;
paramRange = linspace(myParamOptimal-deltaParam,myParamOptimal+deltaParam,20);
resnorm0 = sum(getResiduals(dataTable, y_optimal).^2); 
resnorm = zeros(size(paramRange));
epsilon = zeros(size(paramRange));
for ii = 1:length(paramRange)
    myParam = paramRange(ii);
    y = setParams(y_optimal,13,paramNum,myParam);
    myResnorm = sum(getResiduals(dataTable, y).^2);                                                                                                                                                                                                                                            

    epsilon(ii) = myParam-myParamOptimal;
    resnorm(ii) = myResnorm-resnorm0;
end

figure;
hold on;
plot(epsilon,resnorm,'-o','LineWidth',1)
end
