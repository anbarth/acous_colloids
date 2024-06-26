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

%% reversal: plot rescaled eta vs t
% equiv state sets:
% low sigma: (0.44, 0.02), (0.61, 0.02), (0.61, 60V, 0.1)
% med sigma: (0.44, 0.5), (0.61, 0.09), (0.61, 60V, 0.5)
% high sigma: (0.44, 10), (0.61, 0.15), (0.61, 60V, 0.7)
% even higher sigma: (0.61, 5), (0.61, 60V, 50)

%% stress cessation: plot rate/rate_init vs t

%% rate cessation: plot stress/stress_init vs t

%% rate cessation: plot x vs t