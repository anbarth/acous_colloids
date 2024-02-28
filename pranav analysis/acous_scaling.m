%Acoustic scaling script
%Each volume fraction data contains viscosity values for n voltages x m stresses
%stresses={0.1,0.2,0.4.0.8,1,2,4,8,10,20,40,80,100,200,400...}
%voltages={5,10,20,40,60,80,100};
%For low phi stress sweeps, only torques>10^-6 N.s(uncorrected) appear to
%make sense. Gives non-monotonic dependence of eta on phi otherwise.
CSS = (50/19)^3;
CSR = 19/50;
CSV = CSS/CSR;
%phi=0.20, 0.25, 0.30, 0.35
%all_data = {sigma_1Pa};
%data_title = ["sigma 1Pa"];
% phi=0.40
% all_data = {sigma_1Pa,sigma_1Pa_1};
% data_title = ["sigma 1Pa", "sigma 1Pa 1"];
% phi=0.44
% all_data = {sigma_01Pa,sigma_02Pa,sigma_04Pa,sigma_08Pa,sigma_1Pa,sigma_2Pa,sigma_4Pa,sigma_8Pa,sigma_10Pa,sigma_4Pa_40V_10s,sigma_08Pa_100V_rep,sigma_4Pa_100V_rep};
% data_title = ["sigma 01Pa","sigma 02Pa","sigma 04Pa","sigma 08Pa","sigma 1Pa","sigma 2Pa","sigma 4Pa","sigma 8Pa","sigma 10Pa","sigma 4Pa 40V 10s","sigma 08Pa rep 100V","sigma 4Pa rep 100V"];
% phi=0.46
% all_data = {sigma_01Pa,sigma_02Pa,sigma_04Pa,sigma_08Pa,sigma_1Pa,sigma_2Pa,sigma_4Pa,sigma_8Pa,sigma_10Pa,sigma_08Pa_40V_10s,sigma_4Pa_40V_10s,sigma_08Pa_100V_rep,sigma_4Pa_100V_rep};
% data_title = ["sigma 01Pa","sigma 02Pa","sigma 04Pa","sigma 08Pa","sigma 1Pa","sigma 2Pa","sigma 4Pa","sigma 8Pa","sigma 10Pa","sigma 08Pa 40V 10s","sigma 4Pa 40V 10s","sigma 08Pa rep 100V","sigma 4Pa rep 100V"];
% phi=0.48
% all_data = {sigma_01Pa,sigma_02Pa,sigma_04Pa,sigma_08Pa,sigma_1Pa,sigma_2Pa,sigma_4Pa,sigma_8Pa,sigma_10Pa,sigma_08Pa_40V_10s,sigma_8Pa_40V_10s,sigma_08Pa_repeat};
% data_title = ["sigma_01Pa","sigma_02Pa","sigma_04Pa","sigma_08Pa","sigma_1Pa","sigma_2Pa","sigma_4Pa","sigma_8Pa","sigma_10Pa","sigma_08Pa_1","sigma_8Pa_1","sigma_08Pa_repeat",];
% phi=0.50
% all_data = {sigma_01Pa,sigma_02Pa,sigma_04Pa,sigma_08Pa,sigma_1Pa,sigma_2Pa,sigma_4Pa,sigma_8Pa,sigma_10Pa,sigma_20Pa,sigma_08Pa_40V_10s,sigma_10Pa_40V_10s,sigma_08Pa_100V_rep,sigma_10Pa_100V_rep};
% data_title = ["sigma 01Pa","sigma 02Pa","sigma 04Pa","sigma 08Pa","sigma 1Pa","sigma 2Pa","sigma 4Pa","sigma 8Pa","sigma 10Pa","sigma 20Pa","sigma 08Pa 40V 10s","sigma 10Pa 40V 10s","sigma 08Pa rep 100V","sigma 10Pa rep 100V"];
% phi=0.52
% all_data = {sigma_01Pa,sigma_02Pa,sigma_04Pa,sigma_08Pa,sigma_1Pa,sigma_2Pa,sigma_4Pa,sigma_8Pa,sigma_10Pa,sigma_20Pa,sigma_08Pa_40V_10s,sigma_08Pa_100V_rep,sigma_10Pa_40V_10s,sigma_10Pa_100V_rep};
% data_title = ["sigma_01Pa","sigma_02Pa","sigma_04Pa","sigma_08Pa","sigma_1Pa","sigma_2Pa","sigma_4Pa","sigma_8Pa","sigma_10Pa","sigma_20Pa","sigma_08Pa_40V_10s","sigma_08Pa_100V_rep","sigma_10Pa_40V_10s","sigma_10Pa_100V_rep"];
% phi=0.53
% all_data = {sigma_01Pa,sigma_02Pa,sigma_04Pa,sigma_08Pa,sigma_1Pa,sigma_2Pa,sigma_4Pa,sigma_8Pa,sigma_10Pa,sigma_20Pa,sigma_40Pa,sigma_08Pa_40V_10s,sigma_08Pa_100V_rep,sigma_20Pa_40V_10s,sigma_20Pa_100V_rep};
% data_title = ["sigma 01Pa","sigma 02Pa","sigma 04Pa","sigma 08Pa","sigma 1Pa","sigma 2Pa","sigma 4Pa","sigma 8Pa","sigma 10Pa","sigma 20Pa","sigma 40Pa","sigma 08Pa 40V 10s","sigma 08Pa 100V rep","sigma 20Pa 40V 10s","sigma 20Pa 100V rep"];
% phi=0.54
% all_data = {sigma_01Pa,sigma_02Pa,sigma_04Pa,sigma_08Pa,sigma_1Pa,sigma_2Pa,sigma_4Pa,sigma_8Pa,sigma_10Pa,sigma_20Pa,sigma_40Pa,sigma_80Pa,sigma_08Pa_40V_10s,sigma_40Pa_40V_10s};
% data_title = ["sigma 01Pa","sigma 02Pa","sigma 04Pa","sigma 08Pa","sigma 1Pa","sigma 2Pa","sigma 4Pa","sigma 8Pa","sigma 10Pa","sigma 20Pa","sigma 40Pa","sigma 80Pa","sigma 08Pa 40V 10s","sigma 40Pa 40V 10s"];
% phi=0.55
 all_data = {sigma_01Pa,sigma_02Pa,sigma_04Pa,sigma_08Pa,sigma_1Pa,sigma_2Pa,sigma_4Pa,sigma_8Pa,sigma_10Pa,sigma_20Pa,sigma_40Pa,sigma_80Pa,sigma_100Pa,sigma_200Pa,sigma_400Pa};
 data_title = ["sigma_01Pa","sigma_02Pa","sigma_04Pa","sigma_08Pa","sigma_1Pa","sigma_2Pa","sigma_4Pa","sigma_8Pa","sigma_10Pa","sigma_20Pa","sigma_40Pa","sigma_80Pa","sigma_100Pa","sigma_200Pa","sigma_400Pa"];


% all_data = {sigma_01Pa,sigma_02Pa,sigma_04Pa,sigma_08Pa,sigma_1Pa,sigma_2Pa,sigma_4Pa,sigma_8Pa,sigma_10Pa,sigma_4Pa_40V_10s,sigma_08Pa_100V_rep,sigma_4Pa_100V_rep};
% data_title = ["sigma 01Pa","sigma 02Pa","sigma 04Pa","sigma 08Pa","sigma 1Pa","sigma 2Pa","sigma 4Pa","sigma 8Pa","sigma 10Pa","sigma 4Pa 40V 10s","sigma 08Pa rep 100V","sigma 4Pa rep 100V"];
% all_data = {sigma_01Pa,sigma_02Pa,sigma_04Pa,sigma_08Pa,sigma_1Pa,sigma_2Pa,sigma_4Pa,sigma_8Pa,sigma_10Pa,sigma_08Pa_40V_10s,sigma_8Pa_40V_10s,sigma_08Pa_repeat};
% data_title = ["sigma_01Pa","sigma_02Pa","sigma_04Pa","sigma_08Pa","sigma_1Pa","sigma_2Pa","sigma_4Pa","sigma_8Pa","sigma_10Pa","sigma_08Pa_1","sigma_8Pa_1","sigma_08Pa_repeat"];
%Calibration
for i=1:length(all_data)
    all_data{i}(:,2) = all_data{i}(:,2)*CSR;
    all_data{i}(:,3) = all_data{i}(:,3)*CSS;
    all_data{i}(:,4) = all_data{i}(:,4)*CSV;
end

%Raw plots
for i=1:length(all_data)
    figure;
    plot(all_data{i}(:,1),all_data{i}(:,4),'x-','MarkerSize',8,'LineWidth',2);
    xlabel('Time, $t$ (s)','Interpreter','latex');
    ylabel({'Viscosity','$<\eta>$ (Pa.s)'},'Interpreter','latex');
    set(gca,'FontSize',18);
    title(data_title(i));
end
%Stress sweeps
figure;
loglog(stress_sweep(:,3)*CSS,stress_sweep(:,4)*CSV,'x-','MarkerSize',8,'LineWidth',2);
hold on;
loglog(stress_sweep_2(:,3)*CSS,stress_sweep_2(:,4)*CSV,'x-','MarkerSize',8,'LineWidth',2);
loglog(stress_sweep_3(:,3)*CSS,stress_sweep_3(:,4)*CSV,'x-','MarkerSize',8,'LineWidth',2);
xlabel('Stress, $\sigma$ (Pa)','Interpreter','latex');
ylabel({'Viscosity','$<\eta>$ (Pa.s)'},'Interpreter','latex');
set(gca,'FontSize',18);
title(data_title(i));

% figure;
% loglog(stress_sweep_phi_020(:,3)*CSS,stress_sweep_phi_020(:,4)*CSV,'x-','MarkerSize',8,'LineWidth',2);
% hold on;
% loglog(stress_sweep_phi_025(:,3)*CSS,stress_sweep_phi_025(:,4)*CSV,'x-','MarkerSize',8,'LineWidth',2);
% loglog(stress_sweep_phi_030(:,3)*CSS,stress_sweep_phi_030(:,4)*CSV,'x-','MarkerSize',8,'LineWidth',2);
% loglog(stress_sweep_phi_035(:,3)*CSS,stress_sweep_phi_035(:,4)*CSV,'x-','MarkerSize',8,'LineWidth',2);
% loglog(stress_sweep_phi_040(:,3)*CSS,stress_sweep_phi_040(:,4)*CSV,'x-','MarkerSize',8,'LineWidth',2);
% xlabel('Stress, $\sigma$ (Pa)','Interpreter','latex');
% ylabel({'Viscosity','$<\eta>$ (Pa.s)'},'Interpreter','latex');
% set(gca,'FontSize',18);
% title(data_title(i));

%short vs long app
% figure;
% plot(all_data{i}(:,1),all_data{i}(:,4),'x-','MarkerSize',8,'LineWidth',2);
% xlabel('Time, $t$ (s)','Interpreter','latex');
% ylabel({'Viscosity','$<\eta>$ (Pa.s)'},'Interpreter','latex');
% set(gca,'FontSize',18);
% title(data_title(i));


% phi=0.44
% all_data = {sigma_01Pa,sigma_02Pa,sigma_04Pa,sigma_08Pa,sigma_1Pa,sigma_2Pa,sigma_4Pa,sigma_8Pa,sigma_10Pa,sigma_4Pa_40V_10s,sigma_08Pa_100V_rep,sigma_4Pa_100V_rep};
% data_title = ["sigma 01Pa","sigma 02Pa","sigma 04Pa","sigma 08Pa","sigma 1Pa","sigma 2Pa","sigma 4Pa","sigma 8Pa","sigma 10Pa","sigma 4Pa 40V 10s","sigma 08Pa rep 100V","sigma 4Pa rep 100V"];
% phi=0.46
% all_data = {sigma_01Pa,sigma_02Pa,sigma_04Pa,sigma_08Pa,sigma_1Pa,sigma_2Pa,sigma_4Pa,sigma_8Pa,sigma_10Pa,sigma_08Pa_40V_10s,sigma_4Pa_40V_10s,sigma_08Pa_100V_rep,sigma_4Pa_100V_rep};
% data_title = ["sigma 01Pa","sigma 02Pa","sigma 04Pa","sigma 08Pa","sigma 1Pa","sigma 2Pa","sigma 4Pa","sigma 8Pa","sigma 10Pa","sigma 08Pa 40V 10s","sigma 4Pa 40V 10s","sigma 08Pa rep 100V","sigma 4Pa rep 100V"];
% phi=0.48
% all_data = {sigma_01Pa,sigma_02Pa,sigma_04Pa,sigma_08Pa,sigma_1Pa,sigma_2Pa,sigma_4Pa,sigma_8Pa,sigma_10Pa,sigma_08Pa_40V_10s,sigma_8Pa_40V_10s,sigma_08Pa_repeat};
% data_title = ["sigma_01Pa","sigma_02Pa","sigma_04Pa","sigma_08Pa","sigma_1Pa","sigma_2Pa","sigma_4Pa","sigma_8Pa","sigma_10Pa","sigma_08Pa_1","sigma_8Pa_1","sigma_08Pa_repeat",];
% phi=0.50
% all_data = {sigma_01Pa,sigma_02Pa,sigma_04Pa,sigma_08Pa,sigma_1Pa,sigma_2Pa,sigma_4Pa,sigma_8Pa,sigma_10Pa,sigma_20Pa,sigma_08Pa_40V_10s,sigma_10Pa_40V_10s,sigma_08Pa_100V_rep,sigma_10Pa_100V_rep};
% data_title = ["sigma 01Pa","sigma 02Pa","sigma 04Pa","sigma 08Pa","sigma 1Pa","sigma 2Pa","sigma 4Pa","sigma 8Pa","sigma 10Pa","sigma 20Pa","sigma 08Pa 40V 10s","sigma 10Pa 40V 10s","sigma 08Pa rep 100V","sigma 10Pa rep 100V"];
% phi=0.52
% all_data = {sigma_01Pa,sigma_02Pa,sigma_04Pa,sigma_08Pa,sigma_1Pa,sigma_2Pa,sigma_4Pa,sigma_8Pa,sigma_10Pa,sigma_20Pa,sigma_08Pa_40V_10s,sigma_08Pa_100V_rep,sigma_10Pa_40V_10s,sigma_10Pa_100V_rep};
% data_title = ["sigma_01Pa","sigma_02Pa","sigma_04Pa","sigma_08Pa","sigma_1Pa","sigma_2Pa","sigma_4Pa","sigma_8Pa","sigma_10Pa","sigma_20Pa","sigma_08Pa_40V_10s","sigma_08Pa_100V_rep","sigma_10Pa_40V_10s","sigma_10Pa_100V_rep"];
% phi=0.53
% all_data = {sigma_01Pa,sigma_02Pa,sigma_04Pa,sigma_08Pa,sigma_1Pa,sigma_2Pa,sigma_4Pa,sigma_8Pa,sigma_10Pa,sigma_20Pa,sigma_40Pa,sigma_08Pa_40V_10s,sigma_08Pa_100V_rep,sigma_20Pa_40V_10s,sigma_20Pa_100V_rep};
% data_title = ["sigma 01Pa","sigma 02Pa","sigma 04Pa","sigma 08Pa","sigma 1Pa","sigma 2Pa","sigma 4Pa","sigma 8Pa","sigma 10Pa","sigma 20Pa","sigma 40Pa","sigma 08Pa 40V 10s","sigma 08Pa 100V rep","sigma 20Pa 40V 10s","sigma 20Pa 100V rep"];
% phi=0.54
% all_data = {sigma_01Pa,sigma_02Pa,sigma_04Pa,sigma_08Pa,sigma_1Pa,sigma_2Pa,sigma_4Pa,sigma_8Pa,sigma_10Pa,sigma_20Pa,sigma_40Pa,sigma_80Pa,sigma_08Pa_40V_10s,sigma_40Pa_40V_10s};
% data_title = ["sigma 01Pa","sigma 02Pa","sigma 04Pa","sigma 08Pa","sigma 1Pa","sigma 2Pa","sigma 4Pa","sigma 8Pa","sigma 10Pa","sigma 20Pa","sigma 40Pa","sigma 80Pa","sigma 08Pa 40V 10s","sigma 40Pa 40V 10s"];
% phi=0.55
% all_data = {sigma_01Pa,sigma_02Pa,sigma_04Pa,sigma_08Pa,sigma_1Pa,sigma_2Pa,sigma_4Pa,sigma_8Pa,sigma_10Pa,sigma_20Pa,sigma_40Pa,sigma_80Pa,sigma_100Pa,sigma_200Pa,sigma_400Pa};
% data_title = ["sigma_01Pa","sigma_02Pa","sigma_04Pa","sigma_08Pa","sigma_1Pa","sigma_2Pa","sigma_4Pa","sigma_8Pa","sigma_10Pa","sigma_20Pa","sigma_40Pa","sigma_80Pa","sigma_100Pa","sigma_200Pa","sigma_400Pa"];
