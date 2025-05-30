function eta  = eta_WC(eta0,phi0,phimu,sigmastar,phi,sigma)

f =  exp(-sigmastar./sigma);
phiJ = phi0*(1-f) + phimu*f;
if phi < phiJ
    eta =  eta0 * ( phiJ - phi).^(-2);
else
    eta = Inf;
end

%eta = min(1e7,eta);