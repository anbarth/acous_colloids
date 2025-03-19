play_with_CV_again_03_17;
y_init = y_handpicked_03_17;
log_y_init = log(abs(y_init));
myModelHandle = @modelHandpickedAllExp;



% check that initial guess looks ok before continuing
%show_F_vs_xc_x(dataTable,y_init,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',1,'ShowErrorBars',true);
%show_F_vs_x(dataTable,y_init,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',1,'ShowErrorBars',true);
%return

lower_bounds = -Inf*ones(size(y_init));
upper_bounds = Inf*ones(size(y_init));

%costfxn = @(y)  sum(get_residuals(acoustics_free_data,y,myModelHandle).^2);
residualsfxn = @(log_y) get_residuals(restricted_data_table,logParamsToParams(log_y,3),myModelHandle);
costfxn = @(log_y)  sum(get_residuals(restricted_data_table,logParamsToParams(log_y,3),myModelHandle).^2);

% fminsearch does NOT wanna solve this problem!!!
% optsFminsearch = optimset('MaxFunEvals',3e6,'MaxIter',3e6);
% log_y_fminsearch = fminsearch(costfxn,log_y_init,optsFminsearch);
% y_fminsearch = logParamsToParams(log_y_fminsearch,3);


% constrain unused values, on the theory this might help fmincon converge
% (without the constraints, it quickly converges, but fails to improve on
% y_init...)
log_D_lower = -Inf*ones(numPhi,numV);
log_D_lower(:,volts_to_exclude_indices) = 0;
log_D_lower(no_acoustic_vol_frac_indices,2:end) = 0;
log_sigmastar_lower = -Inf*ones(1,numV);
log_sigmastar_lower(volts_to_exclude_indices) = 0;
lb_con = zipParamsHandpickedAll(-Inf,-Inf,-Inf,-Inf,-Inf,log_sigmastar_lower,log_D_lower,0*ones(1,numPhi));
ub_con = -1*lb_con;

optsFmincon = optimoptions('fmincon','Algorithm','sqp','MaxFunctionEvaluations',2e4);
log_y_fmincon = fmincon(costfxn,log(abs(y_init)),[],[],[],[],lb_con,ub_con,[],optsFmincon);
y_fmincon = logParamsToParams(log_y_fmincon,3);
% zero out unused values
[eta0, phi0, delta, A, width, sigmastar, D] = unzipParamsHandpickedAll(y_fmincon,13);
D(:,volts_to_exclude_indices) = 0;
D(no_acoustic_vol_frac_indices,2:end) = 0;
sigmastar(volts_to_exclude_indices) = 0;
y_fmincon = zipParamsHandpickedAll(eta0, phi0, delta, A, width, sigmastar, D, zeros(1,13));

optsLsq = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt');
[log_y_lsq,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,log_y_init,lower_bounds,upper_bounds,optsLsq);
y_lsq = logParamsToParams(log_y_lsq,3);

%return

plot_C_phi_V(may_ceramic_09_17,y_init); title('init')
plot_C_phi_V(may_ceramic_09_17,y_fmincon); title('fmincon')
plot_C_phi_V(may_ceramic_09_17,y_lsq); title('lsq')

figure; hold on;
plot_sigmastar(y_init);
plot_sigmastar(y_fminsearch);
plot_sigmastar(y_lsq);
legend('init','fmincon','lsqnonlin')

