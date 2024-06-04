load('data/equiv_states_05_22.mat')

phi0 = 0.6792;
phi1 = 0.44;
phi2 = 0.59;

%% first plot rescaled eta vs stress
fig_sweeps = figure;
ax_sweeps = axes('Parent', fig_sweeps,'XScale','log','YScale','log');
ax_sweeps.XLabel.String = '\sigma (Pa)';
ax_sweeps.YLabel.String = '\eta(\phi_0-\phi)^2 (Pa s)';
hold(ax_sweeps,'on');

[sigma44, eta44] = getStressSweep(phi44_equiv_05_22.sweep_init);
[sigma44_low, eta44_low] = getStressSweep(phi44_equiv_05_22.low_sweep_init);
sigma44 = [sigma44_low;sigma44];
eta44 = [eta44_low;eta44];
rescaledEta44 = (phi0-phi1)^2*eta44;
plot(sigma44,rescaledEta44,'-o','LineWidth',1)

[sigma59, eta59] = getStressSweep(phi59_equiv_05_22.sweep_init);
[sigma59_low, eta59_low] = getStressSweep(phi59_equiv_05_22.low_sweep_init);
sigma59 = [sigma59_low;sigma59];
eta59 = [eta59_low;eta59];
rescaledEta59 = (phi0-phi2)^2*eta59;
plot(sigma59,rescaledEta59,'-o','LineWidth',1)
%close;

%% then plot rescaled eta for reversal
figure; hold on;
rescaledEtaVsT(phi44_equiv_05_22.sig50_rev,(phi0-phi1)^2);
rescaledEtaVsT(phi59_equiv_05_22.sig6p5_rev,(phi0-phi2)^2);
%close;

% plot rate/rate_init for stress cessation

% plot stress/stress_init for rate cessation

%% for 44%, show eta vs t for different time resolutions
figure; hold on;
etaVsT(phi44_equiv_05_22.sig50_01);
etaVsT(phi44_equiv_05_22.sig50_001);
etaVsT(phi44_equiv_05_22.sig50_0001);
title('\phi=44%, \sigma=50pa, varying time resolutions')
legend('1/0.1s', '1/0.01s','1/0.001s')
%close

%% for 59%, show different stresses at same time resolution
fig_eta = figure;
ax_eta = axes('Parent', fig_eta); %,'YScale','log'
hold(ax_eta,'on')
fig_rate = figure;
ax_rate = axes('Parent', fig_rate); %,'YScale','log'
hold(ax_rate,'on')
tests = {phi59_equiv_05_22.sig1000_001,phi59_equiv_05_22.sig100_001,phi59_equiv_05_22.sig6p5_001};
for ii = 1:3
    myTest = tests{ii};
    eta = getViscosity(myTest);
    rate = getRate(myTest);
    t = getTime(myTest);
    plot(ax_eta,t,eta-mean(eta),'LineWidth',1)
    plot(ax_rate,t,rate-mean(rate),'LineWidth',1)
end
legend(ax_eta,'1000pa','100pa','6.5pa')
legend(ax_rate,'1000pa','100pa','6.5pa')
xlabel(ax_eta,'t (s)')
ylabel(ax_eta,'viscosity-mean viscosity (pa s)')
xlabel(ax_rate,'t (s)')
ylabel(ax_rate,'rate-mean rate (1/s)')
%close

%% plot 44% and 59% at the same time resolution
test59 = phi59_equiv_05_22.sig6p5_005;
test44 = phi44_equiv_05_22.sig50_005;

figure; hold on;
rescaledEtaVsT(test59,(phi0-phi2)^2);
rescaledEtaVsT(test44,(phi0-phi1)^2);
title('equivalent states, same time resolution')
legend('59%','44%')
%close

figure; hold on;
rate59 = getRate(test59);
t59 = getTime(test59);
rate44 = getRate(test44);
t44 = getTime(test44);
plot(t59,rate59-mean(rate59),'LineWidth',1);
plot(t44,rate44-mean(rate44),'LineWidth',1);
title('equivalent states, same time resolution')
legend('59%','44%')
ylabel('rate-mean(rate) (1/s)')
xlabel('t (s)')
%close





%% plot stress sweeps from small plate, big plate, and 5/22 equiv states
bigPlateTable = ceramic_data_table_03_02;
smallPlateTable = march_data_table_05_02;

myPhi = [phi1, phi2];
smallPlatePhi = [0.4398, 0.5907];
bigPlatePhi = [0.44, 0.59];
colors = ["#0072BD",	"#D95319"];

fig_eta = figure;
ax_eta = axes('Parent', fig_eta,'XScale','log','YScale','log');
%ax_eta.XLabel.String = '\sigma (rheometer Pa)';
%ax_eta.YLabel.String = '\eta (rheometer Pa s)';
ax_eta.XLabel.String = '\sigma (Pa)';
ax_eta.YLabel.String = '\eta (Pa s)';
hold(ax_eta,'on');

for ii=1:2

    mySmallPlateData = smallPlateTable(smallPlateTable(:,1)==smallPlatePhi(ii) & smallPlateTable(:,3)==0, :);
    myBigPlateData = bigPlateTable(bigPlateTable(:,1)==bigPlatePhi(ii) & bigPlateTable(:,3)==0, :);
    myColor = colors(ii);
    sigma_small = mySmallPlateData(:,2);
    eta_small = mySmallPlateData(:,4);

    sigma_big = myBigPlateData(:,2);
    eta_big = myBigPlateData(:,4);
    
    % sort in order of ascending sigma
    [sigma_small,sortIdx] = sort(sigma_small,'ascend');
    eta_small = eta_small(sortIdx);

    [sigma_big,sortIdx] = sort(sigma_big,'ascend');
    eta_big = eta_big(sortIdx);
    
    %plot(ax_eta,sigma_small*19,(phi0-smallPlatePhi(ii))^2*eta_small*25, '-d','Color',myColor,'LineWidth',1);
    %plot(ax_eta,sigma_big,(phi0-bigPlatePhi(ii))^2*eta_big, '--o','Color',myColor,'LineWidth',1);
    plot(ax_eta,sigma_big,eta_big, '--o','Color',myColor,'LineWidth',1);
    plot(ax_eta,sigma_small*19,eta_small*25, '-d','Color',myColor,'LineWidth',1);
    if ii==1
        %plot(ax_eta,sigma44,rescaledEta44,'-o','LineWidth',2,'Color',myColor);
        plot(ax_eta,sigma44,eta44,'-o','LineWidth',2,'Color',myColor);
    else
        %plot(ax_eta,sigma59,rescaledEta59,'-o','LineWidth',2,'Color',myColor);
        plot(ax_eta,sigma59,eta59,'-o','LineWidth',2,'Color',myColor);
    end
end
legend('big plate (february)','small plate (march)','5/22 experiments')
close;