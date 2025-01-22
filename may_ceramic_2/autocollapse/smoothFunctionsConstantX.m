function [phi, sigma] = smoothFunctionsConstantX(x,paramsVector)

[eta0, phi0, delta, A, width, sigmastarParams, alpha, beta, q0params, q1params] = unzipReducedParams(paramsVector);

V = 0;
sigmastar = sigmastarParams(1)*V^2 + sigmastarParams(2)*V + sigmastarParams(3);
q0 = q0params(1)*V + q0params(2);
q1 = q1params(1)*V + q1params(2);


phi = [linspace(0,phi0-0.011,1000) phi0-logspace(-2,-4)];
dphi = phi0-phi;
D = 1./( (q0*dphi).^alpha + (q1*dphi).^(alpha+beta) );
%D = 1./dphi;

Q = 1./D;

finv = @(y) y*sigmastar./(1-y);
sigma = finv(x*Q);

phi = phi(sigma>0);
sigma = sigma(sigma>0);

end