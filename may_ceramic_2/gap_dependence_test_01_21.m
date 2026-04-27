load('gap_dependence_phi56_01_21.mat')

CSV=(50/19)^3;

tests = {gap_dependence_phi56_01_21.d1p5mm_10pa_100v,...
    gap_dependence_phi56_01_21.d1mm_10pa_100v,...
    gap_dependence_phi56_01_21.d07mm_10pa_100v,...
    gap_dependence_phi56_01_21.d05mm_10pa_100v};

t_on = [8.2,14.8,14.8,14.8];

figure; hold on;
%ax1=gca;ax1.YScale='log';
prettyplot;
xlim([-5 10])
for ii=1:length(tests)
    test = tests{ii};
    eta = getViscosity(test,1,CSV);
    t = getTime(test);
    
    % get eta before perturbation
    eta0 = mean(eta(t>2.7 & t<7.8));

    %plot(t-t_on(ii),eta/eta0,'LineWidth',1.5);
    plot(t-t_on(ii),eta,'LineWidth',1.5);
end

legend('1.5mm','1.0mm','0.7mm','0.5mm')
xlabel('Time since perturbation (s)')
ylabel('Normalized viscosity \eta/\eta_0')
