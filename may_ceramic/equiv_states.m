load("equiv_states_06_25.mat");

%% stress sweeps (include weird extra stresses for 61%)
[sig44,eta44] = getStressSweep(equiv_states_06_25.phi44_sweep1);
sig44(end+1) = 0.01; eta44(end+1) = getBaselineViscosity(equiv_states_06_25.phi44_sig001);
sig44(end+1) = 0.02; eta44(end+1) = getBaselineViscosity(equiv_states_06_25.phi44_sig002);
[sig44,sortIdx] = sort(sig44,'ascend');
eta44 = eta44(sortIdx);

[sig61,eta61] = getStressSweep(equiv_states_06_25.phi61_sweep1);
sig61(end+1) = 0.02; eta61(end+1) = getBaselineViscosity(equiv_states_06_25.phi61_sig002);
sig61(end+1) = 0.01; eta61(end+1) = getBaselineViscosity(equiv_states_06_25.phi61_sig001);
sig61(end+1) = 0.15; eta61(end+1) = getBaselineViscosity(equiv_states_06_25.phi61_sig015);
sig61(end+1) = 0.09; eta61(end+1) = getBaselineViscosity(equiv_states_06_25.phi61_sig009);
[sig61,sortIdx] = sort(sig61,'ascend');
eta61 = eta61(sortIdx);

figure; hold on; ax1=gca; ax1.XScale = 'log'; ax1.YScale = 'log';
plot(sig44,eta44,'-o','LineWidth',1)
plot(sig61,eta61,'-o','LineWidth',1)
close

%% use sig=0.01 values to infer "true" phi values
% linear fit from find_phi0
phi0 = 0.7011;
m = 6.0828;
phi_low = phi0-eta44(sig44==0.01).^(-1/2)/m;
phi_high = phi0-eta61(sig61==0.01).^(-1/2)/m;

%% rescaled stress sweeps (include weird extra stresses for 61%)
figure; hold on; ax1=gca; ax1.XScale = 'log'; ax1.YScale = 'log';
plot(sig44,eta44*(phi0-phi_low)^2,'-o','LineWidth',1)
plot(sig61,eta61*(phi0-phi_high)^2,'-o','LineWidth',1)
close

%% equiv state sets:
% low sigma: (0.44, 0.02), (0.61, 0.02), (0.61, 60V, 0.1)
% med sigma: (0.44, 0.5), (0.61, 0.09), (0.61, 60V, 0.5)
% high sigma: (0.44, 10), (0.61, 0.15), (0.61, 60V, 0.7)
% even higher sigma: (0.61, 5), (0.61, 60V, 50)

%% reversal: plot rescaled eta vs t
% figure; title('reversal, low stress');
% plotReversal(equiv_states_06_25.phi44_sig002_rev,30,(phi0-phi_low)^2);
% plotReversal(equiv_states_06_25.phi61_sig002_rev,3*60,(phi0-phi_high)^2);
% plotReversal(equiv_states_06_25.phi61_sig01_60V_rev,90,(phi0-phi_high)^2);
% 
% figure; title('reversal, medium stress');
% plotReversal(equiv_states_06_25.phi44_sig05_rev,30,(phi0-phi_low)^2);
% plotReversal(equiv_states_06_25.phi61_sig009_rev,2*60,(phi0-phi_high)^2);
% plotReversal(equiv_states_06_25.phi61_sig05_60V_rev,30,(phi0-phi_high)^2);
% 
% figure; title('reversal, high stress');
% plotReversal(equiv_states_06_25.phi44_sig10_rev,30,(phi0-phi_low)^2);
% plotReversal(equiv_states_06_25.phi61_sig015_rev,90,(phi0-phi_high)^2);
% plotReversal(equiv_states_06_25.phi61_sig07_60V_rev,30,(phi0-phi_high)^2);

%% stress cessation: plot rate/rate_init vs t
% figure; title('stress cessation, low stress');
% plotStressCessation(equiv_states_06_25.phi61_sig002_stress_cess,3*60);
% plotStressCessation(equiv_states_06_25.phi61_sig01_60V_stress_cess,90);
% plotStressCessation(equiv_states_06_25.phi44_sig002_stress_cess,30);
% 
% figure; title('stress cessation, medium stress');
% plotStressCessation(equiv_states_06_25.phi61_sig009_stress_cess,2*60);
% plotStressCessation(equiv_states_06_25.phi61_sig05_60V_stress_cessation,30);
% plotStressCessation(equiv_states_06_25.phi44_sig05_stress_cess,30);
% 
% figure; title('stress cessation, high stress');
% plotStressCessation(equiv_states_06_25.phi61_sig015_stress_cess,90);
% plotStressCessation(equiv_states_06_25.phi61_sig07_60V_stress_cess,30);
% plotStressCessation(equiv_states_06_25.phi44_sig10_stress_cess,30);
% 
% figure; title('stress cessation, even higher stress')
% plotStressCessation(equiv_states_06_25.phi61_sig5_stress_cessation,30)
% plotStressCessation(equiv_states_06_25.phi61_sig50_60V_stress_cessation,30)

%% rate cessation: plot stress/stress_init vs t
% figure; title('rate cessation, low stress');
% plotRateCessation(equiv_states_06_25.phi44_sig002_rate_cess,30);
% plotRateCessation(equiv_states_06_25.phi61_sig002_rate_cess,3*60);
% plotRateCessation(equiv_states_06_25.phi61_sig01_60V_rate_cess,90);
% 
% figure; title('rate cessation, medium stress');
% plotRateCessation(equiv_states_06_25.phi44_sig05_rate_cess,30);
% plotRateCessation(equiv_states_06_25.phi61_sig009_rate_cess,2*60);
% plotRateCessation(equiv_states_06_25.phi61_sig05_60V_rate_cessation,30);
% 
% figure; title('rate cessation, high stress');
% plotRateCessation(equiv_states_06_25.phi44_sig10_rate_cess,30);
% plotRateCessation(equiv_states_06_25.phi61_sig015_rate_cess,90);
% plotRateCessation(equiv_states_06_25.phi61_sig07_60V_rate_cess,30);

%% check all acoustic applications
figure; hold on;
xlim([-10 10])
xline(0)
xline(-5)
plotAcousGap(equiv_states_06_25.phi61_sig01_60V_rev,90);
plotAcousGap(equiv_states_06_25.phi61_sig05_60V_rev,30);
plotAcousGap(equiv_states_06_25.phi61_sig07_60V_rev,30);
plotAcousGap(equiv_states_06_25.phi61_sig01_60V_stress_cess,90);
plotAcousGap(equiv_states_06_25.phi61_sig05_60V_stress_cessation,30);
plotAcousGap(equiv_states_06_25.phi61_sig07_60V_stress_cess,30);
plotAcousGap(equiv_states_06_25.phi61_sig50_60V_stress_cessation,30);
plotAcousGap(equiv_states_06_25.phi61_sig01_60V_rate_cess,90);
plotAcousGap(equiv_states_06_25.phi61_sig05_60V_rate_cessation,30);
plotAcousGap(equiv_states_06_25.phi61_sig07_60V_rate_cess,30);



%% rate cessation: plot x vs t