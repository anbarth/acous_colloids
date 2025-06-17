% some model for thermal expansion of the medium
a = @(phi) 1+phi;
b = @(phi) 1/1000;
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
u1 = @(phi1,phi2,rho1,rho2,m) (phi2*m-rho2)./(phi2.*rho1-phi1.*rho2);
u2 = @(phi1,phi2,rho1,rho2,m) (rho1-phi1*m)./(phi2.*rho1-phi1.*rho2);
rho1 = @(T) rho(phi1(T),T);
rho2 = @(T) rho(phi2(T),T);
%phi_LLPS = @(m,T) (phi2(T).*rho1(T) - phi1(T).*rho2(T)) ./ (m*(phi2(T)-phi1(T))+rho1(T)-rho2(T));
phi_LLPS = @(m,T) 1./(u1(phi1(T),phi2(T),rho1(T),rho2(T),m)+u2(phi1(T),phi2(T),rho1(T),rho2(T),m));
%rho_LLPS = @(m,T) m./(u1(phi1(T),phi2(T),rho1(T),rho2(T),m)+u2(phi1(T),phi2(T),rho1(T),rho2(T),m));

% conservation of mass:
rho_binodal = @(phi,T)  u1(phi,phi1(T),phi2(T)).*rho1(T) + u2(phi,phi1(T),phi2(T)).*rho2(T);



% plot the binodal line
figure; hold on;
xlabel('\phi'); ylabel('T')
T = linspace(0,Tstar);
plot(phi1(T),T,'k');
plot(phi2(T),T,'k');
xlim([min(phi1(T)) max(phi2(T))])
ylim([min(T) max(T)])

% plot the line followed in the experiment
phi_i = 0.58; % initial concentration
T_exp = linspace(Tstar,0); % temperature range
rho_i = rho(phi,T_exp(1)); % initial density
m = rho_i/phi_i; % mass M/N

% TODO need to make it kink at the boundary
% this equation is only OK bc rho doesn't actually have any
% phi-dependence.... how does it work when there is phi-dependence
%rho_without_LLPS = rho(phi_i,T_exp);
rho_without_LLPS = (a(0)+b(0)*T)/(m-1)*m;
phi_without_LLPS = rho_without_LLPS/m;
phi_exp = zeros(size(T_exp));
for i = 1:length(T_exp)
    if phi_without_LLPS(i) > phi1(T_exp(i)) && phi_without_LLPS(i) < phi2(T_exp(i))
        phi_exp(i) = phi_LLPS(m,T_exp(i));
    else
        phi_exp(i) = phi_without_LLPS(i);
    end
end
plot(phi_without_LLPS,T_exp,'r-')
plot(phi_exp,T_exp,'k-')

rho_exp = m*phi_exp;
figure; hold on; xlabel('T'); ylabel('\rho')
plot(T_exp,m*phi_without_LLPS,'r-')
plot(T_exp,rho_exp,'k-')
%plot(T_exp,rho1(T_exp),'b-')
%plot(T_exp,rho2(T_exp),'g-')
