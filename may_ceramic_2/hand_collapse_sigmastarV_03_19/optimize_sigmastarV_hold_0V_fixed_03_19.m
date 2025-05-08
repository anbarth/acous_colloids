%avg_sigmastar_03_19;

% y0V = y_lsq_0V;
% sigmastarV = y(7:12);
% y_init = sigmastarV;
y_init = y;
log_y_init = log(abs(y_init));
myModelHandle = @modelHandpickedSigmastarV;
dataTable = may_ceramic_09_17;

%show_F_vs_xc_x(dataTable,y_init,myModelHandle)
%return

lower_bounds = -Inf*ones(size(y_init));
upper_bounds = Inf*ones(size(y_init));
lower_bounds(1:6) = log_y_init(1:6);
upper_bounds(1:6) = log_y_init(1:6);
lower_bounds(13:end) = log_y_init(13:end);
upper_bounds(13:end) = log_y_init(13:end);

%costfxn = @(y)  sum(get_residuals(acoustics_free_data,y,myModelHandle).^2);
residualsfxn = @(log_y) get_residuals(dataTable,logParamsToParams(log_y,3),myModelHandle);
costfxn = @(log_y)  sum(get_residuals(dataTable,logParamsToParams(log_y,3),myModelHandle).^2);

%optsFminsearch = optimset('MaxFunEvals',3e6,'MaxIter',3e6);
%log_y_fminsearch = fminsearch(costfxn,log_y_init,optsFminsearch);
%y_fminsearch = logParamsToParams(log_y_fminsearch,3);

optsLsq = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt');
[log_y_lsq,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,log_y_init,lower_bounds,upper_bounds,optsLsq);
y_lsq = logParamsToParams(log_y_lsq,3);

optsFmincon = optimoptions('fmincon','Algorithm','sqp','MaxFunctionEvaluations',2e4);
log_y_fmincon = fmincon(costfxn,log(abs(y_init)),[],[],[],[],lower_bounds,upper_bounds,[],optsFmincon);
y_fmincon = logParamsToParams(log_y_fmincon,3);

return
%%
phiRange = 13:-1:1;
showLines = false;
show_F_vs_x(dataTable,y_fmincon,myModelHandle,'PhiRange',phiRange,'ShowLines',showLines,'ShowInterpolatingFunction',false,'ShowErrorBars',false)
show_F_vs_xc_x(dataTable,y_fmincon,myModelHandle,'PhiRange',phiRange,'ShowLines',showLines,'ShowInterpolatingFunction',false,'ShowErrorBars',false)

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
