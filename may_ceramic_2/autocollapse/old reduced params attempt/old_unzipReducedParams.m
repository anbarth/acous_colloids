function [eta0, phi0, delta, alpha, A, width, sigmastarParams,  b, phistarParams, Cphi0params] = unzipReducedParams(y)

eta0 = y(1);
phi0 = y(2);
delta = y(3);
alpha = y(4);
A = y(5);
width = y(6);
sigmastarParams = y(7:9);
b = y(10);
phistarParams = y(11:12);
Cphi0params = y(13:14);

end