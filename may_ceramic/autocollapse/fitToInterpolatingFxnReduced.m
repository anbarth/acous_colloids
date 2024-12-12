function y_fit_red = fitToInterpolatingFxnReduced(dataTable,y_red)
    % y should be a COMPLETE params vector (so it needs filler values for
    % A, delta, width, eta0 -- should be your initial guess)
    % treat all collapse params (so, yRestricted) as constraints as they
    % will be kept constant
    numPhi = length(unique(dataTable(:,1)));
    y = reducedParamsToFullParams(y_red);
    constraints = setParams(y,numPhi,'eta0',NaN,'A',NaN,'delta',NaN,'width',NaN);
    interpolatingParams_init = removeConstraintsFromParamVec(y,constraints);
    costfxncon = @(yRes) sum(getResidualsCon(dataTable,yRes,constraints).^2);
    opts = optimoptions('fminunc','Display','off');
    interpolatingParams_optimal = fminunc(costfxncon,interpolatingParams_init,opts);
    y_fit = mergeParamsAndConstraints(interpolatingParams_optimal,constraints);
    [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_fit,numPhi);
    [eta0old, phi0old, deltaold, Aold, widthold, sigmastarParams, alpha, b, q0params, q1params] = unzipReducedParams(y_red);
    y_fit_red = zipReducedParams(eta0,phi0,delta,A,width,sigmastarParams,alpha,b,q0params,q1params);
end