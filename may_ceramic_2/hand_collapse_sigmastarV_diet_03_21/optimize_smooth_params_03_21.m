%build_smooth_parameters_03_24;
y_init = y_smooth_restricted;
log_y_init = log(abs(y_init));
myModelHandle = @modelLogisticCSigmastarV;
dataTable = restricted_data_table;

% initial guess puts some x>1 -- fix this by scaling down C
y_init(10) = y_init(10);
[x,~,~,~,~,~,~] = myModelHandle(dataTable, y_init);
disp(max(x))

show_F_vs_xc_x(dataTable,y_init,myModelHandle); 
%show_F_vs_x(dataTable,y_init,myModelHandle); xlim([1e-1 1.5])
return

lower_bounds = -Inf*ones(size(y_init));
upper_bounds = Inf*ones(size(y_init));

%costfxn = @(y)  sum(get_residuals(acoustics_free_data,y,myModelHandle).^2);
residualsfxn = @(log_y) get_residuals(dataTable,logParamsToParams(log_y,3),myModelHandle);
costfxn = @(log_y)  sum(get_residuals(dataTable,logParamsToParams(log_y,3),myModelHandle).^2);

%optsFminsearch = optimset('MaxFunEvals',3e6,'MaxIter',3e6);
%log_y_fminsearch = fminsearch(costfxn,log_y_init,optsFminsearch);
%y_fminsearch = logParamsToParams(log_y_fminsearch,3);

optsLsq = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt');
[log_y_lsq,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,log_y_init,lower_bounds,upper_bounds,optsLsq);
y_lsq = logParamsToParams(log_y_lsq,3);

lb_con = -Inf*ones(size(y_init));
lb_con(5+excluded_V_indices)=0;
lb_con(12+excluded_phi_indices)=0;
ub_con = -1*lb_con;
optsFmincon = optimoptions('fmincon','Algorithm','interior-point','MaxFunctionEvaluations',2e4);
log_y_fmincon = fmincon(costfxn,log_y_init,[],[],[],[],lb_con,ub_con,[],optsFmincon);
y_fmincon = logParamsToParams(log_y_fmincon,3);

return
%%
phiRange = 10;
showLines = true;
show_F_vs_x(dataTable,y_lsq,myModelHandle,'PhiRange',phiRange,'ShowLines',showLines,'ShowInterpolatingFunction',false,'ShowErrorBars',false)
show_F_vs_xc_x(dataTable,y_lsq,myModelHandle,'PhiRange',phiRange,'ShowLines',showLines,'ShowInterpolatingFunction',false,'ShowErrorBars',false)

%%
D_init = y_init(13:end);
D_fminsearch = y_fminsearch(13:end);
D_lsq = y_lsq(13:end);
D_fmincon = y_fmincon(13:end);

figure; hold on;
makeAxesLogLog;
plot(phi0-phi_list,D_init,'ok-');
plot(phi0-phi_list,D_fminsearch,'or-');
plot(phi0-phi_list,D_lsq,'ob-');
plot(phi0-phi_list,D_fmincon,'og-');
