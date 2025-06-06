% some model for thermal expansion of a single phase
a = @(phi) phi;
b = @(phi) 0;
u = @(phi,T) a(phi)+b(phi).*T;

% parameters describing the shape of the phase boundary in the E-phi plane
c_left = 0.03;
c_right = 0.03;
Tstar = 1;
phistar = 0.6;

% left & right branches of the phase boundary in the E-phi plane
phi1 = @(T) phistar - c_left*(Tstar-T).^(1/2);
phi2 = @(T) phistar + c_right*(Tstar-T).^(1/2);

% n1, n2 are particle number densities of phase 1 and phase 2
% eta = n1 eta1 + n2 eta2
n1 = @(phi,phi1,phi2) phi1./phi .* (phi2-phi)./(phi2-phi1);
n2 = @(phi,phi1,phi2) phi2./phi .* (phi-phi1)./(phi2-phi1);
u1 = @(T) u(phi1(T),T);
u2 = @(T) u(phi2(T),T);
u_binodal = @(phi,T)  n1(phi,phi1(T),phi2(T)).*u1(T) + n2(phi,phi1(T),phi2(T)).*u2(T);



% plot the binodal line
figure; hold on;
xlabel('\phi'); ylabel('T')
T = linspace(0,Tstar);
plot(phi1(T),T,'k');
plot(phi2(T),T,'k');

phi = 0.58;
xline(phi)
figure; hold on;
xlabel('T'); ylabel('volume per particle u(T)')
plot(T,u(phi,T),'k')
plot(T,u_binodal(phi,T),'r')

%%% wait shouldnt u1=V1/N1 just be 1/phi1?
%%% I am definitely getting confused bc im thinking of a true one component
%%% system where concentration and density are the same. it might be more
%%% helpful to think of them as separate things....