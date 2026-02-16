% material parameters
phi0 = 0.62;
eta0 = 0.23; % [ Pa s ]

% activity-free rheology
%eta_0V = @(phi,sigma) min(1e7, eta0*(phi0-phi).^(-2));
%eta_0V = @(phi,sigma) eta0*(phi0-phi).^(-2).*( max(0,sigma-1) ).^-1;
eta_0V = @(phi,sigma) eta0*(phi0-phi).^(-2);

% parameters describing the shape of the phase boundary in the E-phi plane
f = @(sigma) exp(-1*sigma/10);
a_left = @(sigma) 0.1*f(sigma);
a_right = @(sigma) 0.03*(f(sigma)).^(1/5);
%a_left = @(sigma) 0.1; a_right = @(sigma) 0.015;
%Estar = @(sigma) 0.4+(sigma/10)^(1/6);
%Estar = @(sigma) 0.4+0.03*sigma; % [ MV/m ]
Estar = @(sigma) 0.4;
%phistar = @(sigma) 0.6;
phistar = @(sigma) 0.58;

% left & right branches of the phase boundary in the E-phi plane
phi1 = @(E,sigma) phistar(sigma) - a_left(sigma)*(E-Estar(sigma)).^(1/2);
phi2 = @(E,sigma) min(phi0*ones(size(sigma)), phistar(sigma) + a_right(sigma)*(E-Estar(sigma)).^(1/2));

% calculating the viscosity for a suspension in the 2-phase region:
% n1, n2 are particle number densities of phase 1 and phase 2 (ie N1/N, N2/N)
% eta = v1 eta1 + v2 eta2
n1 = @(phi,phi1,phi2) phi1/phi * (phi2-phi)/(phi2-phi1);
n2 = @(phi,phi1,phi2) phi2/phi * (phi-phi1)/(phi2-phi1);
v1 = @(phi,phi1,phi2) (phi2-phi)/(phi2-phi1); % V1/V
v2 = @(phi,phi1,phi2) (phi-phi1)/(phi2-phi1); % V2/V
eta1 = @(E,sigma) eta_0V(phi1(E,sigma),sigma);
eta2 = @(E,sigma) eta_0V(phi2(E,sigma),sigma);
eta_binodal = @(phi,E,sigma)  v1(phi,phi1(E,sigma),phi2(E,sigma))*eta1(E,sigma) + v2(phi,phi1(E,sigma),phi2(E,sigma))*eta2(E,sigma);

%eta_binodal = @(phi,E,sigma) 1./( v1(phi,phi1(E,sigma),phi2(E,sigma))./eta1(E,sigma) + v2(phi,phi1(E,sigma),phi2(E,sigma))./eta2(E,sigma) );



% for a given viscosity, solve for the equi-viscosity line phi(E)
phi_equi_viscosity = @(eta,E,sigma) phi1(E,sigma).*phi2(E,sigma).*(eta1(E,sigma)-eta2(E,sigma)) ./ ( eta*(phi2(E,sigma)-phi1(E,sigma))+eta1(E,sigma).*phi1(E,sigma)-eta2(E,sigma).*phi2(E,sigma) );

