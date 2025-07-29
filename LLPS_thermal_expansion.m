% some model for thermal expansion of the medium
a = @(phi) 1+phi;
b = @(phi) 0.001+0.01*phi+0.01*phi.^2;
rho = @(phi,T) a(phi)+b(phi).*T;
phi_m_T = @(m,T) fzero( @(x) rho(x,T)/m-x ,0.5);



% parameters describing the shape of the phase boundary in the E-phi plane
c_left = 0.03;
c_right = 0.03;
Tstar = 1;
phistar = 0.6;

% left & right branches of the phase boundary in the E-phi plane
phi1 = @(T) phistar - c_left*(Tstar-T).^(1/2);
phi2 = @(T) phistar + c_right*(Tstar-T).^(1/2);

% u_i = V_i/N
% n_i = N_i/N
rho1 = @(T) rho(phi1(T),T);
rho2 = @(T) rho(phi2(T),T);
u1 = @(m,T) (phi2(T)*m-rho2(T))./(phi2(T).*rho1(T)-phi1(T).*rho2(T));
u2 = @(m,T) (rho1(T)-phi1(T)*m)./(phi2(T).*rho1(T)-phi1(T).*rho2(T));
phi_LLPS = @(m,T) 1./(u1(m,T)+u2(m,T));




% plot the binodal line
figure; hold on;
xlabel('\phi'); ylabel('T')
T = linspace(0,Tstar);
plot(phi1(T),T,'k');
plot(phi2(T),T,'k');
xlim([min(phi1(T)) max(phi2(T))])
ylim([min(T) max(T)])

% plot the line followed in the experiment
phi_i = 0.59; % initial concentration
T_exp = linspace(Tstar,0); % temperature range
rho_i = rho(phi_i,T_exp(1)); % initial density
m = rho_i/phi_i; % mass M/N

phi_without_LLPS = zeros(size(T_exp));

phi_exp = zeros(size(T_exp));
for i = 1:length(T_exp)
    phi_without_LLPS(i) = phi_m_T(m,T_exp(i));
    if phi_without_LLPS(i) > phi1(T_exp(i)) && phi_without_LLPS(i) < phi2(T_exp(i))
        phi_exp(i) = phi_LLPS(m,T_exp(i));
    else
        phi_exp(i) = phi_without_LLPS(i);
    end
end
plot(phi_without_LLPS,T_exp,'r-')
plot(phi_exp,T_exp,'k-')

rho_exp = m*phi_exp;
rho_without_LLPS = m*phi_exp;
figure; hold on; xlabel('T'); ylabel('\rho')
plot(T_exp,rho_without_LLPS,'r-')
plot(T_exp,rho_exp,'k-')
%plot(T_exp,rho1(T_exp),'b-')
%plot(T_exp,rho2(T_exp),'g-')

figure; hold on; xlabel('T'); ylabel('u1, u2')
plot(T_exp,u1(m,T_exp))
plot(T_exp,u2(m,T_exp))
plot(T_exp, u1(m,T_exp)+u2(m,T_exp))

%figure; hold on; xlabel('T'); ylabel('phi')
%plot(T_exp,rho_without_LLPS)
%plot(T_exp,m*phi_LLPS(m,T_exp))

figure; hold on; xlabel('T'); ylabel('\rho_1, \rho_2')
T = linspace(0,Tstar);
plot(T,rho1(T))
plot(T,rho2(T))