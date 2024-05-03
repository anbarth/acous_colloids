my_data = march_data_table_05_02;

% edit this list to change what's included in the fit
%phis = [44,48,52,56,59];
phis = unique(my_data(:,1));
phi0 = 0.67;
maxSigma = 0;



no_acoustics = my_data(my_data(:,3)==0, :);
phi = no_acoustics(:,1);
sigma = no_acoustics(:,2);
eta = no_acoustics(:,4);
delta_eta = no_acoustics(:,5);



% only include volume fractions listed at the top
include_me = false(size(phi));
for ii=1:length(phi)
    if any(phis==phi(ii))
        include_me(ii) = true;
    end
end
% only include stresses below maxSigma
if maxSigma ~= 0
    for ii=1:length(sigma)
        if sigma(ii) > maxSigma
            include_me(ii) = false;
        end
    end
end


phi = phi(include_me);
sigma = sigma(include_me);
eta = eta(include_me);

% eta = A*(phi_0 (1-f) + phi_mu f - phi)^-2
% x(1) = A
% x(2) = sigma*
% x(3) = phi_mu
k=1;
f = @(sigma,sigmastar) exp(-(sigmastar./sigma).^k);
fitfxn = @(x) x(1)*( phi0*(1-f(sigma,x(2))) + x(3)*f(sigma,x(2)) - phi ).^(-2);
costfxn = @(x) sum(( (fitfxn(x)-eta)./eta ).^2);  

constraintMatrix = zeros(3,3);
constraintVector = [0,0,0];
upper_bounds = [Inf,Inf,phi0];
lower_bounds = [0,0,0.59];

opts = optimoptions('fmincon','Display','final','StepTolerance',1e-12);
%opts = optimoptions('fmincon','Display','off');
s = fmincon(costfxn, [0.1, 5, 0.595],constraintMatrix,constraintVector,...
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
    myPhi = phis(ii);
    
    myStress=sigma(phi==myPhi);
    myEta=eta(phi==myPhi);
    myDeltaEta=delta_eta(phi==myPhi);
    myEtaFit=etaFit(phi==myPhi);
    
    % sort in order of ascending sigma
    [myStress,sortIdx] = sort(myStress,'ascend');
    myEta = myEta(sortIdx);
    myDeltaEta = myDeltaEta(sortIdx);
    myEtaFit = myEtaFit(sortIdx);
    
    myColor = cmap(round(1+255*(myPhi-minPhi)/(maxPhi-minPhi)),:);
    plot(myStress,myEta,'o','Color',myColor,'LineWidth',1);
    errorbar(myStress,myEta,myDeltaEta,'.','Color',myColor,'LineWidth',1);
    plot(myStress,myEtaFit,'Color',myColor,'LineWidth',1);
end
%title('stress sweeps');
xlabel('\sigma (Pa)');
ylabel('\eta (Pa s)');

colormap(cmap);
c = colorbar;
c.Ticks = phis;
clim([minPhi maxPhi])