function y_fit = fitToInterpolatingFxn(dataTable,y)
    % y should be a COMPLETE params vector (so it needs filler values for
    % A, delta, width, eta0 -- should be your initial guess)
    % treat all collapse params (so, yRestricted) as constraints as they
    % will be kept constant
    numPhi = length(unique(dataTable(:,1)));
    constraints = setParams(y,numPhi,'eta0',NaN,'A',NaN,'delta',NaN,'width',NaN);
    interpolatingParams_init = removeConstraintsFromParamVec(y,constraints);
    costfxncon = @(yRes) sum(getResidualsCon(dataTable,yRes,constraints).^2);
    opts = optimoptions('fminunc','Display','off');
    interpolatingParams_optimal = fminunc(costfxncon,interpolatingParams_init,opts);
    y_fit = mergeParamsAndConstraints(interpolatingParams_optimal,constraints);
    %[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,numPhi);

end