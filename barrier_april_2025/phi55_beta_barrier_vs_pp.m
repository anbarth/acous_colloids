phi55_sweeps_vary_d_05_09; % populates hList_barrier, beta_barrier
phi55_flat_control_07_08; % populates hList_pp, beta_pp

figure; hold on;
plot(hList_barrier(2:end),beta_barrier(2:end),'ko-')
plot(hList_pp,beta_pp,'bo-')
prettyplot