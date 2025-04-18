file_list = ["y_by_hand_06_26.mat", "y_optimal_06_26.mat", ...
    "y_optimal_simultaneous_fudge_06_26.mat",  ...
    "y_optimal_crossover_06_26.mat", "y_optimal_crossover_simultaneous_fudge_06_26.mat",...
    "y_optimal_delta2_06_27", "y_optimal_delta2_simultaneous_fudge_06_27"];
% 1 = unzip, 2 = unzip fudge, 3 = unzip crossover, 4 = unzip crossover fudge
unzip_key = [1 1 2 3 4 1 1];
names = {"by hand", "power law", "power law + fudge",...
    "crossover fxn", "crossover fxn + fudge",  "fixed delta=2" ,  "fixed delta=2+fudge"};


dataTable = may_ceramic_06_25;
phi_list = unique(dataTable(:,1));
volt_list = [0,5,10,20,40,60,80];
numPhi = length(phi_list);


fig_sigmastar = figure;
ax_sigmastar = axes('Parent', fig_sigmastar);
ax_sigmastar.XLabel.String = 'V';
ax_sigmastar.YLabel.String = '\sigma^* (Pa)';
hold(ax_sigmastar,'on');

fig_C = figure;
ax_C = axes('Parent', fig_C);
ax_C.XLabel.String = '\phi';
ax_C.YLabel.String = 'C(V=0)';
hold(ax_C,'on');

fig_C80 = figure;
ax_C80 = axes('Parent', fig_C80);
ax_C80.XLabel.String = '\phi';
ax_C80.YLabel.String = 'C(V=80)';
hold(ax_C80,'on');

phi0_list = zeros(size(file_list));
eta0_list = zeros(size(file_list));
delta_list = zeros(size(file_list));

for kk=1:length(file_list)
    load(file_list(kk));
    myKey = unzip_key(kk);
    if myKey == 1
        [eta0, phi0, delta, sigmastar, C] = unzipParams(y_optimal,numPhi);
        phi_fudge = zeros(1,numPhi);
    elseif myKey == 2
        [eta0, phi0, delta, sigmastar, C, phi_fudge] = unzipParamsFudge(y_optimal,numPhi);
    elseif myKey == 3
        [eta0, phi0, delta, A, width, sigmastar, C] = unzipParamsCrossover(y_optimal,numPhi);
        phi_fudge = zeros(1,numPhi);
    elseif myKey == 4
        [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,numPhi);
    end

    mod_phi_list = phi_list+phi_fudge';
    plot(ax_sigmastar,volt_list,sigmastar, 'o-', 'LineWidth',1);
    plot(ax_C,mod_phi_list,C(:,1).*(phi0-mod_phi_list), 'o-', 'LineWidth',1);
    plot(ax_C80,mod_phi_list(C(:,7)~=0),C(C(:,7)~=0,7).*(phi0-mod_phi_list(C(:,7)~=0)), 'o-', 'LineWidth',1);

    phi0_list(kk) = phi0;
    eta0_list(kk) = eta0;
    delta_list(kk) = delta;


end
legend(ax_sigmastar,names);
legend(ax_C,names);
legend(ax_C80,names);

disp('phi0')
disp([names{:};phi0_list]');
disp('eta0')
disp([names{:};eta0_list]');
disp('delta')
disp([names{:};delta_list]');

