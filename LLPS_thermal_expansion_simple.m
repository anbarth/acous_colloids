% some model for thermal expansion of the medium
a = @(phi) 1+0.1*phi;
b = @(phi) 0.01*phi;
rho = @(phi,T) a(phi)+b(phi).*T;
c_consistent = @(m,T) fzero( @(x) rho(x,T)/m-x ,0.5);

% parameters describing the shape of the phase boundary in the E-phi plane
c_left = 0.05;
c_right = 0.03;
Tstar = 1;
phistar = 0.6;

% left & right branches of the phase boundary in the E-phi plane
c1 = @(T) phistar - c_left*(Tstar-T).^(1/2);
c2 = @(T) phistar + c_right*(Tstar-T).^(1/2);

% u_i = V_i/N
% n_i = N_i/N
rho1 = @(T) rho(c1(T),T);
rho2 = @(T) rho(c2(T),T);
u1 = @(m,T) (c2(T)*m-rho2(T))./(c2(T).*rho1(T)-c1(T).*rho2(T)); % V1/N
u2 = @(m,T) (rho1(T)-c1(T)*m)./(c2(T).*rho1(T)-c1(T).*rho2(T)); % V2/N
c_LLPS = @(m,T) 1./(u1(m,T)+u2(m,T)); % N/V
phi1 = @(m,T) u1(m,T).*c_LLPS(m,T); % V1/V
phi2 = @(m,T) u2(m,T).*c_LLPS(m,T); % V2/V




% plot the binodal line
figure; hold on; prettyplot;
xlabel('T'); ylabel('c')
T = linspace(0,Tstar);
plot(T,c1(T),'r','LineWidth',2);
plot(T,c2(T),'b','LineWidth',2);
%ylim([min(c1(T)) max(c2(T))])
%xlim([min(T) max(T)])

% plot c vs T outside the binodal
T = linspace(0,2*Tstar);
m=1/0.55; % M/N ~ M/V V/N ~ rho/c ~ 1 / 0.6
c_experiment = zeros(size(T));
for i=1:length(T)
    c_experiment(i) = c_consistent(m,T(i));
end
plot(T(end),c_experiment(end),'kp')
plot(T,c_experiment,'k','LineWidth',2)

% plot c vs T inside the binodal
plot(T,c_LLPS(m,T),'g--','LineWidth',2)

figure; hold on; prettyplot;
xlabel('T'); ylabel('\phi_1,\phi_2')
%ylim([0,1])
Tllps = T(T<=Tstar);
plot(Tllps,phi1(m,Tllps),'r')
plot(Tllps,phi2(m,Tllps),'b')
yline(0)
yline(1)
xlim([min(T) max(T)])