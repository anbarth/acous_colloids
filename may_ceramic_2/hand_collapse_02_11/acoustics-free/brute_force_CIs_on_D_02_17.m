% calculated based on approximately what gives delta SSR = 1
% in find_CI_by_brute_force_wiggling
% and documented in brute_force_CIs_on_D_02_17.pptx

%optimize_C_jardy_02_11
paramsVector = y_lsq_0V;

D = paramsVector(7:end);
D_lower_val = [D(1:5) 0.575 0.855 0.905 0.915 0.973 0.965 0.975 0.995];
D_upper_val = [D(1:5) 0.875 0.971 0.985 0.985 0.995 0.995 0.995  1];

D_neg = D-D_lower_val;
D_pos = D_upper_val-D;

figure; hold on;
ax1=gca; ax1.XScale='log'; ax1.YScale='log';
phi0 = paramsVector(2);
ylabel('D')
xlabel('\phi_0-\phi')
dphi = paramsVector(2)-phi_list;
errorbar(dphi,D,D_neg,D_pos,[],[],'o','LineWidth',1)