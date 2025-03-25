play_with_C_03_25;
y_init = y_handpicked_03_25;
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


% fminsearch arrives at cost 36.5
optsFminsearch = optimset('MaxFunEvals',3e6,'MaxIter',3e6);
log_y_fminsearch_0V = fminsearch(costfxn,log_y_init,optsFminsearch);
y_fminsearch_0V = logParamsToParams(log_y_fminsearch_0V,3);

% lsq arrives at cost 34.2
optsLsq = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt');
[log_y_lsq_0V,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,log_y_init,lower_bounds,upper_bounds,optsLsq);
y_lsq_0V = logParamsToParams(log_y_lsq_0V,3);
% zero out unused entries in D
y_lsq_0V(excluded_phi_indices+6)=0;

% fmincon also arrives at cost 34.2
optsFmincon = optimoptions('fmincon','Algorithm','sqp','MaxFunctionEvaluations',2e4);
log_y_fmincon_0V = fmincon(costfxn,log_y_init,[],[],[],[],lower_bounds,upper_bounds,[],optsFmincon);
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
