function x = smoothFunctionX(phi,sigma,V,paramsVector)

% y = [eta0, phi0, delta, A, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]
[eta0, phi0, delta, A, width, sigmastarParams, alpha, beta, q0params, q1params] = unzipReducedParams(paramsVector);
f = @(sigma,star) sigma./(star+sigma);

sigmastar = sigmastarParams(1)*V^2 + sigmastarParams(2)*V + sigmastarParams(3);
q0 = q0params(1)*V + q0params(2);
q1 = q1params(1)*V + q1params(2);

dphi = phi0-phi;
D = 1/( (q0*dphi)^alpha + (q1*dphi)^(alpha+beta) );

x = D*f(sigma,sigmastar);

end