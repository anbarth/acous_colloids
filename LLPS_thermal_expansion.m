% some model for thermal expansion of the medium
a = @(phi) 1;
b = @(phi) 1/100;
rho = @(phi,T) a(phi)+b(phi).*T;

% parameters describing the shape of the phase boundary in the E-phi plane
c_left = 0.03;
c_right = 0.03;
Tstar = 1;
phistar = 0.6;

% left & right branches of the phase boundary in the E-phi plane
phi1 = @(T) phistar - c_left*(Tstar-T).^(1/2);
phi2 = @(T) phistar + c_right*(Tstar-T).^(1/2);

% n1, n2 are particle number densities of phase 1 and phase 2
%n1 = @(phi,phi1,phi2) phi1./phi .* (phi2-phi)./(phi2-phi1);
%n2 = @(phi,phi1,phi2) phi2./phi .* (phi-phi1)./(phi2-phi1);
v1 = @(phi,phi1,phi2) (phi2-phi)./(phi2-phi1);
v2 = @(phi,phi1,phi2) (phi-phi1)./(phi2-phi1);
rho1 = @(T) rho(phi1(T),T);
rho2 = @(T) rho(phi2(T),T);

% conservation of mass:
rho_binodal = @(phi,T)  v1(phi,phi1(T),phi2(T)).*rho1(T) + v2(phi,phi1(T),phi2(T)).*rho2(T);



% plot the binodal line
figure; hold on;
xlabel('\phi'); ylabel('T')
T = linspace(0,Tstar);
plot(phi1(T),T,'k');
plot(phi2(T),T,'k');

% plot the line followed in the experiment
phi = 0.58; % initial concentration

T0 = max(T);
%xline(phi)
plot(phi*rho(T)/rho(T0),T,'r-')



figure; hold on;
xlabel('T'); ylabel('volume per particle u(T)')
plot(T,u(phi,T),'k')
plot(T,rho_binodal(phi,T),'r')

%%% wait shouldnt u1=V1/N1 just be 1/phi1?
%%% I am definitely getting confused bc im thinking of a true one component
%%% system where concentration and density are the same. it might be more
%%% helpful to think of them as separate things....