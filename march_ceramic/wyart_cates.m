my_data = ceramic_data_table_02_24;

% edit this list to change what's included in the fit
phis = [30,40,44,48,52,56,59];



no_acoustics = my_data(my_data(:,3)==0, :);
phi = no_acoustics(:,1);
sigma = no_acoustics(:,2);
eta = no_acoustics(:,4);

phi_low = [];
sigma_low = [];
eta_low = [];

phi = [phi_low;phi];
sigma = [sigma_low;sigma];
eta = [eta_low;eta];

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

% eta = A*(phi_0 (1-f) + phi_mu f - phi)^-2
% x(1) = A
% x(2) = sigma*
% x(3) = phi_mu
% x(4) = phi_0
fitfxn = @(x) x(1)*( x(4)*(1-exp(-x(2)./sigma)) + x(3)*exp(-x(2)./sigma) - phi ).^(-2);
costfxn = @(x) sum(( (fitfxn(x)-eta)./eta ).^2);  

constraintMatrix = zeros(4,4);
% phi_mu-phi_0 < 0 (phi_mu < phi_0)
constraintMatrix(1,3)=1;
constraintMatrix(1,4)=-1;
constraintVector = [0,0,0,0];
upper_bounds = [Inf,Inf,.8,.8];
lower_bounds = [0,0,0.59,.59];

opts = optimoptions('fmincon','Display','final','StepTolerance',1e-12);
%opts = optimoptions('fmincon','Display','off');
s = fmincon(costfxn, [0.1, 5, 0.595, 0.68],constraintMatrix,constraintVector,...
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
    
    % sort in order of ascending sigma
    [myStress,sortIdx] = sort(myStress,'ascend');
    myEta = myEta(sortIdx);
    myEtaFit = myEtaFit(sortIdx);
    
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