phi = [0.2,0.25,0.3,0.35,0.4,0.44,0.46,0.48,0.5,0.52,0.53,0.54,0.55];
figure;
hold on;
% first, low-phi stuff
load('low_phi_stress_sweeps.mat');
sweeps = {stress_sweep_phi_020,stress_sweep_phi_025,stress_sweep_phi_030,...
    stress_sweep_phi_035,stress_sweep_phi_040};
for ii=1:length(sweeps)
    stress_sweep = sweeps{ii};
    plot(CSS*stress_sweep(:,3),CSV*stress_sweep(:,4),'-o');

end

% now, high phi stuff
high_phis = [44,46,48,50,52,53,54,55];
for ii = 1:length(high_phis)
    matFileName = strcat('phi_0',num2str(high_phis(ii)),'.mat');
    load(matFileName);
    plot(CSS*stress_sweep(:,3),CSV*stress_sweep(:,4),'-o');
end

%figure;

%phi=phi(1:5);
%eta=eta(1:5);
%phi=phi(6:end);
%eta=eta(6:end);



xlabel('\sigma')
ylabel('\eta')
ax1 = gca;
ax1.XScale = 'log';
ax1.YScale = 'log';
