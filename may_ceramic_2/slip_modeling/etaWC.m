function eta = etaWC(phi,sigma) 

phimu = 0.6;
phi0 = 0.64;
f = @(sigma) exp(-1./sigma);
dphi = phi0*(1-f(sigma))+phimu*f(sigma)-phi;
eta = dphi.^(-2);
eta(dphi<0) = Inf;


end