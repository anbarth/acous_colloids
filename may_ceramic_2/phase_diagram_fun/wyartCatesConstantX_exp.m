function [phi, sigma] = wyartCatesConstantX_exp(x,sigmastar,phimu,phi0)

phi = [linspace(0,phi0-0.011,1000) phi0-logspace(-2,-4)];
dphi = phi0-phi;
Q = dphi/(phi0-phimu);

finv = @(y) -sigmastar./log(y);
sigma = finv(x*Q);

phi = phi(sigma>0);
sigma = sigma(sigma>0);

end