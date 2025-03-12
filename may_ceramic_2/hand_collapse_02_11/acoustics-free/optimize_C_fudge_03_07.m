play_with_C_02_11;
y_init = y_handpicked_02_11;
y_init = [y_init zeros(1,13)];
log_y_init = log(abs(y_init));
myModelHandle = @modelHandpickedAllExp0VFudge;

acoustics_free_data = dataTable(dataTable(:,3)==0,:);

% check that initial guess looks ok before continuing
%show_F_vs_xc_x(acoustics_free_data,y_init,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',2);
%show_F_vs_x(acoustics_free_data,y_init,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',2);
%return

lower_bounds = -Inf*ones(size(y_init));
upper_bounds = Inf*ones(size(y_init));

costfxn = @(y)  costWithFudge(acoustics_free_data,y,myModelHandle);
%costfxn = @(log_y)  sum(get_residuals(acoustics_free_data,logParamsToParams(log_y,3),myModelHandle).^2);

%optsFmin = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e5);
%[y_optimal_fmin,fval,exitflag,output,lambda,grad,hessian] = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],optsFmin);
optsFminsearch = optimset('MaxFunEvals',3e6,'MaxIter',3e6);
y_fminsearch_0V = fminsearch(costfxn,y_init,optsFminsearch);

optsFmincon = optimoptions('fmincon','Algorithm','sqp','MaxFunctionEvaluations',2e4);
y_fmincon_0V = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],optsFmincon);
%y_fmincon_0V = logParamsToParams(log_y_fmincon_0V,3);


phiRange = 13:-1:1;
show_F_vs_x(dataTable,y_fmincon_0V,myModelHandle,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)
show_F_vs_xc_x(dataTable,y_fmincon_0V,myModelHandle,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)

return

D_init = y_init(7:end);
D_fminsearch = y_fminsearch_0V_alt(7:end);
D_lsq = y_lsq_0V_alt(7:end);
D_fmincon = y_fmincon_0V(7:end);

figure; hold on;
makeAxesLogLog;
plot(phi0-phi_list,D_init,'ok-');
plot(phi0-phi_list,D_fminsearch,'or-');
plot(phi0-phi_list,D_lsq,'ob-');
plot(phi0-phi_list,D_fmincon,'og-');
