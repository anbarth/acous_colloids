function [phi, sigma] = wyartCatesConstantX(x,sigmastar,phimu,phi0)

phi = [linspace(0,phi0-0.011,1000) phi0-logspace(-2,-4)];
dphi = phi0-phi;
Q = dphi/(phi0-phimu);

finv = @(y) y*sigmastar(1)./(1-y);
sigma = finv(x*Q);

phi = phi(sigma>0);
sigma = sigma(sigma>0);

end