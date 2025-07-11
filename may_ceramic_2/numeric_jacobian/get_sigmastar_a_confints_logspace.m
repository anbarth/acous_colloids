function [sigmastar_0_ci_u,sigmastar_0_ci_l,sigmastar_a_ci_u,sigmastar_a_ci_l] = get_sigmastar_a_confints_logspace(y,dataTable)

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

sigmastar_a_ci_u = sigmastar_a_upper-sigmastar_a;
sigmastar_a_ci_l = sigmastar_a-sigmastar_a_lower;
sigmastar_0_ci_u = sigmastar_0_upper-sigmastar_0;
sigmastar_0_ci_l = sigmastar_0-sigmastar_0_lower;


end