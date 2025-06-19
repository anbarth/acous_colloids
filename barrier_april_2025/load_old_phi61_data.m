CSS = (50/19)^3;
% does not make a huge difference which one you choose here
%t_avg = 20; % consistent with what i did for acous scaling
 t_avg=5; % consistent with what i do for this data set

% version 1: use scaling analysis to get smooth fxn for eta(sigma)
% then just evaluate at the desired sigmas
% my_stress_list = unique(phi61table_05_20(:,2));
% my_stress_list_rheo_units = my_stress_list/CSS;
% % run the above line, then go to
% % may_ceramic_2/03_19/predictions_for_barrier_experiment to generate
% % phi61_rate_hat 
% load("phi61_unobstructed_rate_hat.mat")
% delta_rate_hat = 0; % being lazy for now
% gap = Inf;
% phi61_ref_table = [gap*ones(size(my_stress_list)), my_stress_list, phi61_rate_hat, delta_rate_hat*ones(size(my_stress_list)),ones(size(my_stress_list))];


% version 2: just load in data from may 2024 and draw a cubic spline through it
load("../may_ceramic_2/data/phi61_06_20.mat")
sweepData1 = getStressSweep(phi61_06_20.low_sweep1,t_avg,2,false);
sweepData2 = getStressSweep(phi61_06_20.sweep1,t_avg,2,false);
gap = Inf;
phi61_ref_table1 = [gap*ones(size(sweepData1,1),1), sweepData1, ones(size(sweepData1,1),1)];
phi61_ref_table2 = [gap*ones(size(sweepData2,1),1), sweepData2, ones(size(sweepData2,1),1)];
phi61_ref_table = [phi61_ref_table1;phi61_ref_table2];
phi61_ref_table(:,2) = CSS*phi61_ref_table(:,2);
sweepData = [sweepData1;sweepData2];
sweepData(:,1) = sweepData(:,1)*CSS;

% draw a spline for rate(stress), since that's single-valued
pp = spline(sweepData(:,1),sweepData(:,2));
pp = fnxtr(pp); 
phi61_ref_rate = @(stress) ppval(pp,stress);
% patch up the janky part of the curve
pp2 = replaceSectionWithLine(pp,0.32,10);
phi61_ref_rate_single_val = @(stress) ppval(pp2,stress);
% now build stress(rate)
stress_fake=logspace(log10(0.5*min(sweepData(:,1))),log10(2*max(sweepData(:,1))));
rate_fake=phi61_ref_rate_single_val(stress_fake);
phi61_ref_stress = @(rate) interp1(rate_fake,stress_fake,rate);

% pp2 = spline(sweepData(:,2),sweepData(:,1));
% pp2 = fnxtr(pp2); 
% phi61_ref_stress = @(rate) ppval(pp2,rate);

% version 3: just load in data from may 2024 (datatable version)
% load("../may_ceramic_2/data/may_ceramic_09_17.mat")
% phi = 0.6101;
% myData = may_ceramic_09_17(may_ceramic_09_17(:,1)==phi & may_ceramic_09_17(:,3)==0,:);
% sigma = myData(:,2)*CSS;
% eta = myData(:,4)*CSS;
% delta_eta = myData(:,5)*CSS;
% [sigma,sortIdx]=sort(sigma); eta=eta(sortIdx); delta_eta=delta_eta(sortIdx);
% rate = sigma./eta;
% delta_rate = rate .* delta_eta./eta;
% gap = Inf;
% phi61_ref_table = [gap*ones(size(myData,1),1), sigma, rate, delta_rate, ones(size(myData,1),1)];
% 
% % draw a spline for rate(stress), since that's single-valued
% pp = spline(sigma, rate);
% pp = fnxtr(pp); 
% phi61_ref_rate = @(stress) ppval(pp,stress);