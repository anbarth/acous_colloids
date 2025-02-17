play_with_CV_lsq_2_02_11;
y_init = y_handpicked_02_11;
log_y_init = log(abs(y_init));
myModelHandle = @modelHandpickedAllExp;



% check that initial guess looks ok before continuing
%show_F_vs_xc_x(dataTable,y_init,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',1,'ShowErrorBars',true);
%show_F_vs_x(dataTable,y_init,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',1,'ShowErrorBars',true);
%return

lower_bounds = -Inf*ones(size(y_init));
upper_bounds = Inf*ones(size(y_init));

%costfxn = @(y)  sum(get_residuals(acoustics_free_data,y,myModelHandle).^2);
residualsfxn = @(log_y) get_residuals(dataTable,logParamsToParams(log_y,3),myModelHandle);
costfxn = @(log_y)  sum(get_residuals(dataTable,logParamsToParams(log_y,3),myModelHandle).^2);

%optsFmin = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e5);
%[y_optimal_fmin,fval,exitflag,output,lambda,grad,hessian] = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],optsFmin);
optsFminsearch = optimset('MaxFunEvals',3e6,'MaxIter',3e6);
log_y_fminsearch = fminsearch(costfxn,log_y_init,optsFminsearch);
y_fminsearch = logParamsToParams(log_y_fminsearch,3);

optsLsq = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt');
[log_y_lsq,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,log_y_init,lower_bounds,upper_bounds,optsLsq);
y_lsq = logParamsToParams(log_y_lsq,3);

% feeding results of fminsearch into lsqnonlin does not lower the costfxn any further 
%[log_y_fmin_lsq,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,log_y_fminsearch,lower_bounds,upper_bounds,optsLsq);
%y_fmin_lsq = logParamsToParams(log_y_fmin_lsq,3);

% for some reason fminsearch sends D(1) all the way out to nearly 0, which
% makes numerics tricky (eta-hat starts returning 0 bc x is too small)
% so i manually clip it out here.
y_fminsearch_alt = y_fminsearch;
y_fminsearch_alt(13) = y_init(13);

y_lsq_alt = y_lsq;
y_lsq_alt(13) = y_init(13);

return

plot_C_phi_V(may_ceramic_09_17,y_init); title('init')
plot_C_phi_V(may_ceramic_09_17,y_fminsearch_alt); title('fminsearch')
plot_C_phi_V(may_ceramic_09_17,y_lsq_alt); title('lsq')

figure; hold on;
plot_sigmastar(y_init);
plot_sigmastar(y_fminsearch_alt);
plot_sigmastar(y_lsq_alt);
legend('init','fminsearch','lsqnonlin')

