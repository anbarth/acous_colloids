function phi = getDST(sigma,sigmastar,paramsVector,alpha,D0,phi_list)
% model must be modelHandpickedAllExp0V



eta0 = paramsVector(1);
phi0 = paramsVector(2);
delta = paramsVector(3);
A = paramsVector(4);
width = paramsVector(5);
%sigmastar = paramsVector(6);
D = paramsVector(7:end);

xi0 = (log(A)-log(eta0))/(-2-delta);
m = @(x) (1/2)*(1+tanh(width*( 1/x-1 - xi0 )));
dlogJ_dlogt = @(x) delta+(-2-delta)*m(x);

phi = nan(size(sigma));

for ii=1:length(sigma)
    eqn_S17 = @(x) -2*sigmastar/sigma(ii) - 1/(1-x)*(sigmastar/sigma(ii))*dlogJ_dlogt(x) - 1;
    x_DST = fzero(eqn_S17,0.6);
    phi(ii) = interpConstantX(x_DST,sigma(ii),phi0,sigmastar,D,alpha,D0,phi_list);
end

end
