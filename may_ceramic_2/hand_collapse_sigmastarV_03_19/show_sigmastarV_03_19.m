%optimize_sigmastarV_03_19

% get optimal parameters
y=y_lsq;
sigmastar = y(6:12);
sigmastar_0 = sigmastar(1);
sigmastar_a = sigmastar(2:end)-sigmastar(1);

% transform into correct parameter space for finding CIs
y_log = y; 
y_log(6) = log(y(6));
y_log(7:12) = log(y(7:12)-y(6));
ci = get_conf_ints(dataTable,y_log,@modelHandpickedSigmastarV_logsigmastar)';


log_sigmastar_0_ci = ci(6);
log_sigmastar_a_ci = ci(7:12);

sigmastar_0_upper = sigmastar_0*exp(log_sigmastar_0_ci);
sigmastar_0_lower = sigmastar_0/exp(log_sigmastar_0_ci);
sigmastar_a_upper = sigmastar_a.*exp(log_sigmastar_a_ci);
sigmastar_a_lower = sigmastar_a./exp(log_sigmastar_a_ci);

disp(sigmastar_0)
disp(sigmastar_0_lower)
disp(sigmastar_0_upper)
disp(sigmastar_a)
disp(sigmastar_a_lower)
disp(sigmastar_a_upper)

sigmastar_a_ci_u = sigmastar_a_upper-sigmastar_a;
sigmastar_a_ci_l = sigmastar_a-sigmastar_a_lower;

figure; hold on;
makeAxesLogLog;
prettyplot
xlabel('U_a')
ylabel('\sigma^*_a')
V = [5 10 20 40 60 80];
CSS=(50/19)^3;
errorbar(acoustic_energy_density(V),CSS*sigmastar_a,CSS*sigmastar_a_ci_l,CSS*sigmastar_a_ci_u,'ok')

