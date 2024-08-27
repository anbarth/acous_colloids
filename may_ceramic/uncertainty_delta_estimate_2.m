function uncertainty_delta_estimate_2(dataTable,y_optimal)

%dataTable = may_ceramic_06_25;


%load("y_optimal_lsqnonlin_08_26.mat")
[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13);

% epsilon = 0.05;
% [y_init,resnorm_init] = setDeltaResNorm(dataTable,y_optimal,delta);
% [y_minus,resnorm_minus] = setDeltaResNorm(dataTable,y_optimal,delta-epsilon);
% [y_plus,resnorm_plus] = setDeltaResNorm(dataTable,y_optimal,delta+epsilon);
% disp([resnorm_init resnorm_plus resnorm_minus])

deltaDelta = 0.05;
deltaRange = linspace(delta-deltaDelta,delta+deltaDelta,20);
resnorm = zeros(size(deltaRange));
epsilon = zeros(size(deltaRange));
for ii = 1:length(deltaRange)
    myDelta = deltaRange(ii);
    y = setParams(y_optimal,13,'delta',myDelta);
    myResnorm = sum(getResiduals(dataTable, y).^2);                                                                                                                                                                                                                                            

    epsilon(ii) = myDelta-delta;
    resnorm(ii) = myResnorm;
end

figure;
hold on;
plot(epsilon,resnorm,'-o','LineWidth',1)
end
