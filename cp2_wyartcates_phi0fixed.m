my_cp_data = cp_data_01_05;

% edit this list to change what's included in the fit
phis = [20,25,30,35,40,44,48,50,54];
%phis = [44,48,50,54];
phi0 = .6291;

no_acoustics = my_cp_data(my_cp_data(:,2)==0, :);
phi = no_acoustics(:,1);
sigma = CSS*no_acoustics(:,3);
eta = CSV/1000*no_acoustics(:,4);

phi_low = cp_low_phi(:, 1);
sigma_low = CSS*cp_low_phi(:, 2);
eta_low = CSV/1000*cp_low_phi(:, 3);

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
fitfxn = @(x) x(1)*10^4*( phi0*(1-exp(-x(2)./sigma)) + x(3)*exp(-x(2)./sigma) - phi ).^(-2);
costfxn = @(x) sum(( (fitfxn(x)-eta)./eta ).^2);  
%costfxn = @(x) sum(abs( (fitfxn(x)-eta)./eta ));  

upper_bounds = [Inf,Inf,phi0];
lower_bounds = [0,0,0.55];

opts = optimoptions('fmincon','Display','final','StepTolerance',1e-12);
%opts = optimoptions('fmincon','Display','off');
s = fmincon(costfxn, [2e-6, 10, 0.5501],[],[],...
            [],[],lower_bounds,upper_bounds,[],opts);
%s = fminsearch(costfxn, [0.001, 5, 0.56, 0.6]);
%s = fminsearch(costfxn, [0.001, 20, 0.5]);
        
disp(s);
etaFit = fitfxn(s);

figure;
hold on;
ax1 = gca;
ax1.XScale = 'log';
ax1.YScale = 'log';
colormap turbo;
cmap = colormap;
minPhi = .2;
maxPhi = .55;
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