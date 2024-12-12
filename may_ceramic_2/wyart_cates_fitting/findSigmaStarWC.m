function sigmaStar = findSigmaStarWC(my_data,V,showPlot)
% will do a WC fit to ALL the data in my_data
% so you should trim it to just one voltage beforehand

if nargin<3
    showPlot = false;
end


if V == -1
    my_acoustics = my_data;
else
    my_acoustics = my_data(my_data(:,3)==V, :);
end

phi = my_acoustics(:,1);
sigma = my_acoustics(:,2);
eta = my_acoustics(:,4);
delta_eta = my_acoustics(:,5);

% edit this list to change what's included in the fit
%phis = [44,48,52,56,59];
phi_list = unique(phi);
phi0 = 0.6947;



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

%opts = optimoptions('fmincon','Display','final','StepTolerance',1e-12);
opts = optimoptions('fmincon','Display','off','StepTolerance',1e-12);
%s0 = [0.1, 5, 0.595];
s0 = [0.1, .5, 0.595];

s = fmincon(costfxn, s0,constraintMatrix,constraintVector,...
            [],[],lower_bounds,upper_bounds,[],opts);
        
sigmaStar = s(2);

if showPlot
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
    for ii=1:length(phi_list)
        myPhi = phi_list(ii);
        
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
    c.Ticks = phi_list;
    clim([minPhi maxPhi])
end