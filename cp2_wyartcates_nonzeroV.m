my_cp_data = cp_data_01_18;

% edit this list to change what's included in the fit
phis = [44,48,50,54];
fudge = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
phi_fudge_factors =    [0.2000    0.1698   -0.0302
    0.2500    0.2874    0.0374
    0.3000    0.2828   -0.0172
    0.3500    0.3782    0.0282
    0.4000    0.4114    0.0114
    0.4400    0.4182   -0.0218
    0.4800    0.4580   -0.0220
    0.5000    0.5018    0.0018
    0.5400    0.5523    0.0123];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

my_V = 100;
my_V_data = my_cp_data(my_cp_data(:,2)==my_V, :);
phi = my_V_data(:,1);
sigma = CSS*my_V_data(:,3);
eta = CSV/1000*my_V_data(:,4);

% only include volume fractions listed at the top
include_me = false(size(phi));
for ii=1:length(phi)
    if any(phis/100==phi(ii))
        include_me(ii) = true;
    end
end
phi = phi(include_me);
sigma = sigma(include_me);
eta = eta(include_me);

% fudge the phis
if fudge == 1
    for ii=1:length(phi)
        phi(ii) = phi_fudge_factors(phi_fudge_factors(:,1)==phi(ii),2);
    end
    for jj=1:length(phis)
        phis(jj) = 100*phi_fudge_factors(phi_fudge_factors(:,1)==phis(jj)/100,2);
    end
end

% eta = A*(phi_0 (1-f) + phi_mu f - phi)^-2
% x(1) = A
% x(2) = sigma*
% x(3) = phi_mu
% x(4) = phi_0
fitfxn = @(x) x(1)*10^4*( x(4)*(1-exp(-x(2)./sigma)) + x(3)*exp(-x(2)./sigma) - phi ).^(-2);
costfxn = @(x) sum(( (fitfxn(x)-eta)./eta ).^2);  

constraintMatrix = zeros(4,4);
% phi_mu-phi_0 < 0 (phi_mu < phi_0)
constraintMatrix(1,3)=1;
constraintMatrix(1,4)=-1;
constraintVector = [0,0,0,0];
upper_bounds = [Inf,Inf,.74,.74];
lower_bounds = [0,0,0.5400001,.57];

opts = optimoptions('fmincon','Display','final','StepTolerance',1e-12);
%opts = optimoptions('fmincon','Display','off');
s = fmincon(costfxn, [2e-6, 10, 0.55, 0.59],constraintMatrix,constraintVector,...
            [],[],lower_bounds,upper_bounds,[],opts);
        
disp(s);
etaFit = fitfxn(s);

figure;
hold on;
ax1 = gca;
ax1.XScale = 'log';
ax1.YScale = 'log';
colormap turbo;
cmap = colormap;
minPhi = min(phi);
maxPhi = max(phi);
for ii=1:length(phis)
    myPhi = phis(ii)/100;
    
    myStress=sigma(phi==myPhi);
    myEta=eta(phi==myPhi);
    myEtaFit=etaFit(phi==myPhi);
    
    %myColor = cmap(round(1+255*(0.55-myPhi)/(0.55-0.2)),:);
    myColor = cmap(round(1+255*(myPhi-minPhi)/(maxPhi-minPhi)),:);
    plot(myStress,myEta,'o','Color',myColor);
    plot(myStress,myEtaFit,'Color',myColor);
end
%title('stress sweeps');
xlabel('\sigma (Pa)');
ylabel('\eta (Pa s)');

colormap(cmap);
c = colorbar;
c.Ticks = phis/100;
caxis([minPhi maxPhi])