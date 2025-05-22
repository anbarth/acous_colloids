avg_sigmastar_03_19;
y_init = y;
log_y_init = log(abs(y_init));
myModelHandle = @modelHandpickedSigmastarV;
dataTable = may_ceramic_09_17;

%show_F_vs_xc_x(dataTable,y_init,myModelHandle)
%return

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

optsFmincon = optimoptions('fmincon','Algorithm','sqp','MaxFunctionEvaluations',2e4);
log_y_fmincon = fmincon(costfxn,log(abs(y_init)),[],[],[],[],lower_bounds,upper_bounds,[],optsFmincon);
y_fmincon = logParamsToParams(log_y_fmincon,3);

return
%% SHOW CONF INTS
ci = get_conf_ints(dataTable,y_lsq,@modelHandpickedSigmastarV);
s = ["F0","phi0","delta","A","h","sigma*_0"];
for ii=1:length(s)
    disp(s(ii))
    disp([y_init(ii) y_lsq(ii) ci(ii)])
%     if ii==6
%         ci_l =  y_lsq_0V(ii) - exp(log(y_lsq_0V(ii))-ci(ii));
%         ci_u =  exp(log(y_lsq_0V(ii))+ci(ii)) - y_lsq_0V(ii);
%         disp([y_init(ii) y_lsq_0V(ii) ci_l ci_u])
%     else
%         disp([y_init(ii) y_lsq_0V(ii) ci(ii)])
%     end
end


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
