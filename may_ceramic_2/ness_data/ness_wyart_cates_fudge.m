function [eta0,sigmastar,phimu,phi0] = ness_wyart_cates_fudge(my_data,phi_fudge,showPlot)
%my_data = may_ceramic_09_17;
if nargin < 3
    showPlot = false;
end

phi_list = unique(my_data(:,1));
phi_eff_list = phi_list+phi_fudge;

no_acoustics = my_data(my_data(:,3)==0, :);
phi = no_acoustics(:,1);
sigma = no_acoustics(:,2);
eta = no_acoustics(:,4);
%delta_eta = ones(size(eta));
delta_eta = eta*0.01;

% add in volume fraction fudge factor
phi_eff = zeros(size(phi));
for kk=1:length(phi)
    phi_eff(kk) = phi_eff_list(phi(kk)==phi_list);
end



% eta = A*(phi_0 (1-f) + phi_mu f - phi)^-2
% x(1) = A
% x(2) = sigma*
% x(3) = phi_mu
% x(4) = phi_0

%f = @(sigma,sigmastar) exp(-(sigmastar./sigma).^1);
f = @(sigma,sigmastar) sigma./(sigmastar+sigma);
fitfxn = @(x) x(1)*( x(4)*(1-f(sigma,x(2))) + x(3)*f(sigma,x(2)) - phi_eff ).^(-2);
%costfxn = @(x) sum(( (fitfxn(x)-eta)./delta_eta ).^2);  
costfxn = @(x) sum( log(abs(fitfxn(x)-eta)).^2);  


constraintMatrix = zeros(4,4);
constraintVector = [0,0,0,0];
upper_bounds = [Inf,Inf,1,1];
lower_bounds = [0,0,0,0];
%upper_bounds = [0.2760,Inf,1,0.6561];
%lower_bounds = [0.2760,0,0,0.6561];

opts = optimoptions('fmincon','Display','none','StepTolerance',1e-12);
%opts = optimoptions('fmincon','Display','off');
s = fmincon(costfxn, [0.2760, 0.0958, 0.589, 0.6561],constraintMatrix,constraintVector,...
            [],[],lower_bounds,upper_bounds,[],opts);
 
%s = [0.2760, 0.0958, 0.589, 0.6561];
eta0 = s(1);
sigmastar = s(2);
phimu = s(3);
phi0 = s(4);
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
    minPhi = min(phi_eff_list);
    maxPhi = max(phi_eff_list);
    for ii=1:length(phi_eff_list)
        myPhi = phi_eff_list(ii);
        
        myStress=sigma(phi_eff==myPhi);
        myEta=eta(phi_eff==myPhi);
        myDeltaEta=delta_eta(phi_eff==myPhi);
        myEtaFit=etaFit(phi_eff==myPhi);
        
        % sort in order of ascending sigma
        [myStress,sortIdx] = sort(myStress,'ascend');
        myEta = myEta(sortIdx);
        myDeltaEta = myDeltaEta(sortIdx);
        myEtaFit = myEtaFit(sortIdx);
        
        myMarker = my_vol_frac_markers(ii);
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
    c.Ticks = phi_eff_list;
    clim([minPhi maxPhi])
end

end