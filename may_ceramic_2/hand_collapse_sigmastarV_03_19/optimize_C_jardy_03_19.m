play_with_C_03_19;
y_init = y_handpicked_03_19;
log_y_init = log(abs(y_init));
myModelHandle = @modelHandpickedAllExp0V;

acoustics_free_data = dataTable(dataTable(:,3)==0,:);

% check that initial guess looks ok before continuing
%show_F_vs_xc_x(acoustics_free_data,y_init,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',2);
%show_F_vs_x(acoustics_free_data,y_init,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',2);
%return

lower_bounds = -Inf*ones(size(y_init));
upper_bounds = Inf*ones(size(y_init));

%costfxn = @(y)  sum(get_residuals(acoustics_free_data,y,myModelHandle).^2);
residualsfxn = @(log_y) get_residuals(acoustics_free_data,logParamsToParams(log_y,3),myModelHandle);
costfxn = @(log_y)  sum(get_residuals(acoustics_free_data,logParamsToParams(log_y,3),myModelHandle).^2);

%optsFmin = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e5);
%[y_optimal_fmin,fval,exitflag,output,lambda,grad,hessian] = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],optsFmin);
% optsFminsearch = optimset('MaxFunEvals',3e6,'MaxIter',3e6);
% log_y_fminsearch_0V = fminsearch(costfxn,log_y_init,optsFminsearch);
% y_fminsearch_0V = logParamsToParams(log_y_fminsearch_0V,3);

optsLsq = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt');
[log_y_lsq_0V,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,log_y_init,lower_bounds,upper_bounds,optsLsq);
y_lsq_0V = logParamsToParams(log_y_lsq_0V,3);

% optsFmincon = optimoptions('fmincon','Algorithm','sqp','MaxFunctionEvaluations',2e4);
% log_y_fmincon_0V = fmincon(costfxn,log(abs(y_init)),[],[],[],[],lower_bounds,upper_bounds,[],optsFmincon);
% y_fmincon_0V = logParamsToParams(log_y_fmincon_0V,3);

% if you don't take logs of parameters,
% lsq doesnt perform as well
% residualsfxn2 = @(y) get_residuals(acoustics_free_data,y,myModelHandle);
% costfxn2 = @(y)  sum(get_residuals(acoustics_free_data,y,myModelHandle).^2);
% [y_lsq2,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn2,y_init,lower_bounds,upper_bounds);


return

%% SHOW CONF INTS
%[ci_u,ci_l] = get_conf_ints(acoustics_free_data,y_lsq_0V,myModelHandle,6);
y_log = y_lsq_0V; y_log(6) = log(y_lsq_0V(6));
ci = get_conf_ints(acoustics_free_data,y_log,@modelHandpickedAllExp0V_logsigmastar);
s = ["F0","phi0","delta","A","h","sigma*"];
for ii=1:length(s)
    disp(s(ii))
    if ii==6
        ci_l =  y_lsq_0V(ii) - exp(log(y_lsq_0V(ii))-ci(ii));
        ci_u =  exp(log(y_lsq_0V(ii))+ci(ii)) - y_lsq_0V(ii);
        disp([y_init(ii) y_lsq_0V(ii) ci_l ci_u])
    else
        disp([y_init(ii) y_lsq_0V(ii) ci(ii)])
    end
end


%%
phiRange = 13:-1:1;
show_F_vs_x(dataTable,y_lsq_0V,myModelHandle,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)
show_F_vs_xc_x(dataTable,y_lsq_0V,myModelHandle,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)


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
