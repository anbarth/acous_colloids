play_with_C_03_21;
y_init = y_handpicked_03_21;
log_y_init = log(abs(y_init));
myModelHandle = @modelHandpickedAllExp0V;

acoustics_free_data = dataTable(dataTable(:,3)==0 | dataTable(:,3)==-1,:);

% check that initial guess looks ok before continuing
%show_F_vs_xc_x(acoustics_free_data,y_init,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',2);
%show_F_vs_x(acoustics_free_data,y_init,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',2); xlim([1e-5 1.5])
%return

residualsfxn = @(log_y) get_residuals(acoustics_free_data,logParamsToParams(log_y,3),myModelHandle);
costfxn = @(log_y)  sum(get_residuals(acoustics_free_data,logParamsToParams(log_y,3),myModelHandle).^2);

lower_bounds = -Inf*ones(size(y_init));
upper_bounds = Inf*ones(size(y_init));
lb_con = -Inf*ones(size(y_init));
lb_con(excluded_phi_indices+6) = 0;
ub_con = -1*lb_con;

% fminsearch does not want to cooperate
%optsFminsearch = optimset('MaxFunEvals',3e6,'MaxIter',3e6);
%log_y_fminsearch_0V = fminsearch(costfxn,log_y_init,optsFminsearch);
%y_fminsearch_0V = logParamsToParams(log_y_fminsearch_0V,3);

% lsq does not improve on y_init unless you constrain the unused entries in D
optsLsq = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt');
[log_y_lsq_0V,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,log_y_init,lb_con,ub_con,optsLsq);
y_lsq_0V = logParamsToParams(log_y_lsq_0V,3);
% zero out unused entries in D
y_lsq_0V(excluded_phi_indices+6)=0;

% fmincon also does not improve on y_init unless you constrain the unused entries in D
% fmincon does very slightly better than lsq
optsFmincon = optimoptions('fmincon','Algorithm','sqp','MaxFunctionEvaluations',2e4);
log_y_fmincon_0V = fmincon(costfxn,log_y_init,[],[],[],[],lb_con,ub_con,[],optsFmincon);
y_fmincon_0V = logParamsToParams(log_y_fmincon_0V,3);
% zero out unused entries in D
y_fmincon_0V(excluded_phi_indices+6)=0;

return
%%
phiRange = 13:-1:1;
show_F_vs_x(dataTable,y_fmincon_0V,myModelHandle,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)
show_F_vs_xc_x(dataTable,y_fmincon_0V,myModelHandle,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)

%%
D_init = y_init(7:end);
D_lsq = y_lsq_0V(7:end);
D_fmincon = y_fmincon_0V(7:end);

figure; hold on;
makeAxesLogLog;
plot(phi0-phi_list,D_init,'ok-');
plot(phi0-phi_list,D_lsq,'ob-');
plot(phi0-phi_list,D_fmincon,'og-');
