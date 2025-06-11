function phi = getDST(sigma,sigmastar,paramsVector,alpha,D0,phi_list)
% model must be modelHandpickedAllExp0V



eta0 = paramsVector(1);
phi0 = paramsVector(2);
delta = paramsVector(3);
A = paramsVector(4);
width = paramsVector(5);
%sigmastar = paramsVector(6);
D = paramsVector(7:end);

x0 = log(A/eta0)/(-2-delta);
m = @(logxi) (1/2)*(1+tanh(width*( logxi - x0 )));
dlogJ_dlogxi = @(logxi) delta+(-2-delta)*m(logxi);
logxi = @(x) log(1/x-1);

% syms J(XI)
% xi0 = (A/eta0)^(1/(-2-delta));
% J(XI) = sqrt(A*eta0) * XI^((-2+delta)/2) * ((XI/xi0)^width+(XI/xi0)^(-width))^((-2-delta)/(2*width));
% dJ_dt = diff(J,XI);
% xi = @(x) 1/x-1;
% dlogJ_dlogt = @(xi) eval(xi/J(xi)*dJ_dt(xi));



phi = nan(size(sigma));

for ii=1:length(sigma)
    eqn_S17 = @(x) -2*sigmastar/sigma(ii) - 1/(1-x)*(sigmastar/sigma(ii))*dlogJ_dlogxi(logxi(x)) - 1;
    x_DST = fzero(eqn_S17,0.6);
    phi(ii) = interpConstantX(x_DST,sigma(ii),phi0,sigmastar,D,alpha,D0,phi_list);
end

end
