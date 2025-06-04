% version 1: just load in data from may 2024
% doesn't work bc the stress sweep includes different sigmas than i want
% load("../may_ceramic_2/data/phi61_06_20.mat")
% 
% sweepData1 = getStressSweep(phi61_06_20.low_sweep1,5,2,false);
% sweepData2 = getStressSweep(phi61_06_20.sweep1,5,2,false);
% 
% gap = Inf;
% phi61_ref_table1 = [gap*ones(size(sweepData1,1),1), sweepData1, ones(size(sweepData1,1),1)];
% phi61_ref_table2 = [gap*ones(size(sweepData2,1),1), sweepData2, ones(size(sweepData2,1),1)];
% phi61_ref_table = [phi61_ref_table1;phi61_ref_table2];
% phi61_ref_table(:,2) = CSS*phi61_ref_table(:,2);


% version 2: use scaling analysis to get smooth fxn for eta(sigma)
% then just evaluate at the desired sigmas
my_stress_list = unique(phi61table_05_20(:,2));
my_stress_list_rheo_units = my_stress_list/CSS;
% run the above line, then go to
% may_ceramic_2/03_19/predictions_for_barrier_experiment to generate
% phi61_rate_hat 
load("phi61_unobstructed_rate_hat.mat")
delta_rate_hat = 0; % being lazy for now
gap = Inf;
phi61_ref_table = [gap*ones(size(my_stress_list)), my_stress_list, rate_hat, delta_rate_hat*ones(size(my_stress_list)),ones(size(my_stress_list))];