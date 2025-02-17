function [eta0,sigmastar,phimu] = ness_wyart_cates_fix_phi0(my_data,f,phi0,showPlot)
%my_data = may_ceramic_09_17;
if nargin < 4
    showPlot = false;
end

% edit this list to change what's included in the fit
%phis = [44,48,52,56,59];
phis = unique(my_data(:,1));



no_acoustics = my_data(my_data(:,3)==0, :);
phi = no_acoustics(:,1);
sigma = no_acoustics(:,2);
eta = no_acoustics(:,4);

%delta_eta = ones(size(eta));
delta_eta = eta*0.01;

% only include volume fractions listed at the top
include_me = false(size(phi));
for ii=1:length(phi)
    if any(phis==phi(ii))
        include_me(ii) = true;
    end
end
% only include eta < 1e5
for ii=1:length(eta)
    if eta(ii)>1e5
        include_me(ii) = false;
    end
end


phi = phi(include_me);
sigma = sigma(include_me);
eta = eta(include_me);
delta_eta = delta_eta(include_me);

% eta = A*(phi_0 (1-f) + phi_mu f - phi)^-2
% x(1) = A
% x(2) = sigma*
% x(3) = phi_mu

fitfxn = @(x) x(1)*( phi0*(1-f(sigma,x(2))) + x(3)*f(sigma,x(2)) - phi ).^(-2);
costfxn = @(x) sum(( (fitfxn(x)-eta)./delta_eta ).^2);  
%costfxn = @(x) sum(( (fitfxn(x)-eta)).^2); 
%costfxn = @(x) sum( log(abs(fitfxn(x)-eta)).^2);  

constraintMatrix = zeros(3,3);
constraintVector = [0,0,0];
upper_bounds = [Inf,Inf,1];
lower_bounds = [0,0,0];

opts = optimoptions('fmincon','Display','none','StepTolerance',1e-12);
%opts = optimoptions('fmincon','Display','off');
s = fmincon(costfxn, [0.3, 0.1, 0.6],constraintMatrix,constraintVector,...
            [],[],lower_bounds,upper_bounds,[],opts);
 
%s = [0.2760, 0.0958, 0.587, 0.6561];
eta0 = s(1);
sigmastar = s(2);
phimu = s(3);

%disp(s);
etaFit = fitfxn(s);

if showPlot
    my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">",">",">",">",">",">"];
    figure;
    hold on;
    ax1 = gca;
    ax1.XScale = 'log';
    ax1.YScale = 'log';
    cmap = viridis(256);
    colormap(cmap);
    minPhi = min(phis);
    maxPhi = max(phis);
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
        
        myMarker = 'o';
        myColor = cmap(round(1+255*(myPhi-minPhi)/(maxPhi-minPhi)),:);

        %errorbar(myStress,myEta*(phi0-myPhi)^2,myDeltaEta,strcat(myMarker,''),'Color',myColor,'LineWidth',0.5,'MarkerFaceColor',myColor);
        %plot(myStress,myEtaFit*(phi0-myPhi)^2,'Color',myColor,'LineWidth',1);
        errorbar(myStress,myEta,myDeltaEta,strcat(myMarker,''),'Color',myColor,'LineWidth',0.5,'MarkerFaceColor',myColor);
        plot(myStress,myEtaFit,'Color',myColor,'LineWidth',1);

    
    end
    %title('stress sweeps');
    xlabel('\sigma ');
    ylabel('\eta ');
    
    colormap(cmap);
    c = colorbar;
    c.Ticks = phis;
    clim([minPhi maxPhi])
end

end