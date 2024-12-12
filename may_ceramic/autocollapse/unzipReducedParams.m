function [eta0, phi0, delta, A, width, sigmastarParams, alpha, b, q0params, q1params] = unzipReducedParams(y)

eta0 = y(1);
phi0 = y(2);
delta = y(3);
A = y(4);
width = y(5);
sigmastarParams = y(6:8);
alpha = y(9);
b = y(10);
q0params = y(11:12);
q1params = y(13:14);

end