% material parameters
phi0 = 0.64;
eta0 = 1;
sigmastar = 80;
phimu = 0.62;

% activity-free rheology
eta_0V = @(phi,sigma) eta_WC(eta0,phi0,phimu,sigmastar,phi,sigma);
%eta_0V = @(phi,sigma) eta0*(phi0-phi).^(-2);

% parameters describing the shape of the phase boundary in the E-phi plane
a_left = @(sigma) 0.1-0.085/100*sigma;
a_right = @(sigma) 0.03;
Estar = 1;
phistar = 0.6;

% left & right branches of the phase boundary in the E-phi plane
phi1 = @(E,sigma) phistar - a_left(sigma)*(E-Estar).^(1/2);
phi2 = @(E,sigma) min(phi0, phistar + a_right(sigma)*(E-Estar).^(1/2));

% calculating the viscosity for a suspension in the 2-phase region:
% n1, n2 are particle number densities of phase 1 and phase 2
% eta = n1 eta1 + n2 eta2
n1 = @(phi,phi1,phi2) phi1/phi * (phi2-phi)/(phi2-phi1);
n2 = @(phi,phi1,phi2) phi2/phi * (phi-phi1)/(phi2-phi1);
eta1 = @(E,sigma) eta_0V(phi1(E,sigma),sigma);
eta2 = @(E,sigma) eta_0V(phi2(E,sigma),sigma);
eta_binodal = @(phi,E,sigma)  n1(phi,phi1(E,sigma),phi2(E,sigma))*eta1(E,sigma) + n2(phi,phi1(E,sigma),phi2(E,sigma))*eta2(E,sigma);

% for a given viscosity, solve for the equi-viscosity line phi(E)
phi_equi_viscosity = @(eta,E,sigma) phi1(E,sigma).*phi2(E,sigma).*(eta1(E,sigma)-eta2(E,sigma)) ./ ( eta*(phi2(E,sigma)-phi1(E,sigma))+eta1(E,sigma).*phi1(E,sigma)-eta2(E,sigma).*phi2(E,sigma) );

