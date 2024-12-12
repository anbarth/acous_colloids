function [eta0, phi0, delta, A, width, a2, a1, a0, alpha, beta, b1, b0, c1, c0] = unzipReducedParamsFlat(y)

[eta0, phi0, delta, A, width, sigmastarParams, alpha, beta, q0params, q1params] = unzipReducedParams(y);
a2 = sigmastarParams(1);
a1 = sigmastarParams(2);
a0 = sigmastarParams(3);
b1 = q0params(1);
b0 = q0params(2);
c1 = q1params(1);
c0 = q1params(2);

end