% some model for thermal expansion of the medium
V_M_N_T = @(M,N,T) 1-T/1000;


% parameters describing the shape of the phase boundary in the E-phi plane
c_left = 0.03;
c_right = 0.03;
Tstar = 1;
phistar = 0.6;

% left & right branches of the phase boundary in the E-phi plane
phi1 = @(T) phistar - c_left*(Tstar-T).^(1/2);
phi2 = @(T) phistar + c_right*(Tstar-T).^(1/2);

V1 = @(M,N,T) (phi2(T)*M-rho2(T)*N)./(phi2(T).*rho1(T)-phi1(T).*rho2(T));
V2 = @(M,N,T) (rho1(T)*N-phi1(T)*M)./(phi2(T).*rho1(T)-phi1(T).*rho2(T));
rho1 = @(T) rho(M1,T);
rho2 = @(T) rho(phi2(T),T);
rho_LLPS = @(M,T) M./(V1(M,N,T)+V2(M,N,T));




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
m = rho_i/phi_i; % m=M/N is a constant

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

figure; hold on; xlabel('T'); ylabel('phi')
plot(T_exp,rho_without_LLPS)
plot(T_exp,m*phi_LLPS(m,T_exp))