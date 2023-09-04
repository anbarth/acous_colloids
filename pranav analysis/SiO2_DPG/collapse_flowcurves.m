sigmastar = 8;
phi0 = 0.74;




f = @(sig)exp(-sigmastar ./ sig);
%C = [5,4.2,3.7,3.1,2.4,2,1.6,1];
C = [1,1,1,1,1,1,1,1,1,1,1,1,1];
%B = [1,1,1,0.6,0.5,0.25,0.07,0.02];

phis = 1/100*[20,25,30,35,40,44,46,48,50,52,53,54,55];
data_by_vol_frac = cell(length(phis),1);
load('low_phi_stress_sweeps.mat');
data_by_vol_frac{1} = stress_sweep_phi_020;
data_by_vol_frac{2} = stress_sweep_phi_025;
data_by_vol_frac{3} = stress_sweep_phi_030;
data_by_vol_frac{4} = stress_sweep_phi_035;
data_by_vol_frac{5} = stress_sweep_phi_040;
high_phis = [44,46,48,50,52,53,54,55];
for ii = 1:length(high_phis)
    matFileName = strcat('phi_0',num2str(high_phis(ii)),'.mat');
    load(matFileName);
    data_by_vol_frac{5+ii} = stress_sweep;
end

figure(20);
hold on;

ax1 = gca;
ax1.XScale = 'log';
ax1.YScale = 'log';

colormap turbo;
cmap = colormap;
for ii = 1:length(data_by_vol_frac)
    phi = phis(ii);
    myColor = cmap(round(1+255*(0.55-phi)/(0.55-0.2)),:);
    
    phi_data = data_by_vol_frac{ii};
    sigma = CSS*phi_data(:,3);
    eta = CSV*phi_data(:,4);
    % 0 V data -- eta vs. stress
    %plot(sigma,eta,'-o');
    %xWC = f(sigma) ./ (-1*phi + phi0);
    xWC = C(ii)*f(sigma) ./ (-1*phi + phi0);
    %FWC = B(ii)*eta*(phi0-phi)^2;
    FWC = eta*(phi0-phi)^2;
    plot(xWC,FWC,'-o','Color',myColor);
end
xlabel('x_{WC}')
ylabel('F_{WC}')
legend('20%','25%','30%','35%','40%','44%','46%','48%','50%','52%','53%','54%','55%');

%xWC = f(sigma) ./ (-1*phi + phi0);
