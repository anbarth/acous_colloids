myModelHandle = @modelHandpickedAllExp0V; paramsVector = y_lsq_0V;
eta0 = paramsVector(1);
delta = paramsVector(3);
A = paramsVector(4);
width = paramsVector(5);
xi0 = (A/eta0)^(1/(-2-delta));

syms J(XI)
J(XI) = sqrt(A*eta0) * XI^((-2+delta)/2) * ((XI/xi0)^width+(XI/xi0)^(-width))^((-2-delta)/(2*width));
