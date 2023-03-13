global volt_list stress_list phi_list data_by_vol_frac vol_frac_markers

%phi0 = 0.58;
phi0=phi_iter(end);
%sigmastar = 26.4;
sigmastar = sigma_iter(end);
C = C_iter(end,:);
%C = ones(6,1);
G = G_iter(end,:);
%F = F_iter(end,:);
F = exp(-(sigmastar ./ stress_list));
xc = 4.9368;


% phi0=0.5678; % based on 1/sqrt(eta) vs phi
%sigmastar = 6.1811; % based on flow curve fits
%C = [6,4.8,4,3.3,2.5,2.1,1.6,1];
%G = [1,1,1,1,0.95,0.9,0.85,0.8];

% phi0=0.58; % best collapse for lower 6 phis
% C = [2.4,2,1.7,1.5,1.15,1,0.85,0.6];
% G = [1,1,1,1,0.98,0.95,0.92,0.9];
% xc = 20;
% sigmastar = 26.4;


% phi0=0.56; % best collapse for all 8 phis, but this number is SILLY
% sigmastar = 6.1811; % based on flow curve fits
% C = [2.4,2,1.65,1.3,0.9,0.7,0.47,0.22];
% G = [1,1,1,1,0.97,0.96,0.94,0.92];
% xc = 24;
%sigmastar = 26.4;

%G = [1,1,1,1,1,1,1,1];

%xc = 1/(phi0-phimu); % lower xc a bit to see if you can get a better collapse. F vs xc-x should be linear


%F = exp(-(sigmastar ./ stress_list));
%f = @(sig)exp(-(sigmastar ./ sig).^(1));
%f2 = [7.0928e-08, 2.6632e-04, 0.0163, 0.1277, 0.1928, 0.4391, 0.6626, 0.8140, ...
%     0.8482, 0.9210, 0.9597, 0.9796, 0.9837, 0.9918, 0.9959];

%for jj = 1:length(volt_list)
figure; hold on;
xx_all = zeros(1,0);
H_all = zeros(1,0);
%for ii = 1:length(data_by_vol_frac)
for ii = 1:6
        
    cmap = viridis(256);
    colormap(cmap);
    

    ax1 = gca;
    ax1.XScale = 'log';
    ax1.YScale = 'log';

   
    for jj = 1:length(volt_list)
        
        voltage = volt_list(jj);
        phi = phi_list(ii)/100;
        phi_data = data_by_vol_frac{ii};
        sigma = stress_list(1:size(phi_data,2));
        eta = phi_data(jj,:); % viscosities for just this voltage
        
        myColor = voltage*ones(size(sigma));
        %myColor = phi*ones(size(sigma));
        %myColor = log(sigma);
        
        xWC = G(jj)*C(ii)*F(1:size(phi_data,2)) ./ (-1*phi+phi0);
        xx = abs(1/xc-1./xWC);
        H = eta.*(G(jj)*C(ii)*F(1:size(phi_data,2))).^2;

        myMarker = vol_frac_markers(ii);
        
        scat = scatter(xx,H,[],myColor,'filled',myMarker);
        scat.MarkerFaceAlpha = 1;
        
        xx_all(end+1:end+length(xx)) = xx;
        H_all(end+1:end+length(H)) = H;
        
    end

    xlabel('1/x-1/x_c')
    ylabel('H')
    %title(strcat('\phi=',num2str(phi),', all voltages'));
    %saveas(gcf,strcat('\phi_',phis(ii),'_all_voltages.fig'));
    %
end
%legend('44%','46%','48%','50%','52%','53%','54%','55%');
%plot(logspace(-2,0),0.005*logspace(-2,0).^(-2))
cbh = colorbar ; %Create Colorbar

%xWC = f(sigma) ./ (-1*phi + phi0);

% trim out nan values
trim_me = ~isnan(H_all);
xx_all = xx_all(trim_me);
H_all = H_all(trim_me);

inflectionPointLow = 0.3;
inflectionPointHigh = 3;
xx_low = xx_all(xx_all<inflectionPointLow);
H_low = H_all(xx_all<inflectionPointLow);
fit_low_coeff = polyfit(log(xx_low),log(H_low),1);
fit_low = exp(fit_low_coeff(2))*xx_low.^fit_low_coeff(1);


xx_high = xx_all(xx_all>=inflectionPointHigh);
H_high = H_all(xx_all>=inflectionPointHigh);
fit_high_coeff = polyfit(log(xx_high),log(H_high),1);
fit_high = exp(fit_high_coeff(2))*xx_high.^fit_high_coeff(1);

plot(xx_low,fit_low,'r-.','LineWidth',1.5);
plot(xx_high,fit_high,'r-.','LineWidth',1.5);

disp(['frictionless, low stress: ' num2str(fit_high_coeff(1))]);
disp(['frictional, high stress: ' num2str(fit_low_coeff(1))]);
