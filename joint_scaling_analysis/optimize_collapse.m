dataTable = joint_data_table;
y_init = y_joint;
y_init(1)=-1;
log_y_init = log(abs(y_init));
myModelHandle = @modelHandpickedJoint;

% check inits before continuing
%show_F_vs_x_joint(dataTable,logParamsToParams(log_y_init,1),myModelHandle,'ShowInterpolatingFunction',true); prettyplot; 
%show_F_vs_xc_x_joint(dataTable,logParamsToParams(log_y_init,1),myModelHandle,'ShowInterpolatingFunction',true); prettyplot;
%return

lower_bounds = -Inf*ones(size(y_init));
upper_bounds = Inf*ones(size(y_init));
residualsfxn = @(log_y) get_residuals(dataTable,logParamsToParams(log_y,1),myModelHandle);
costfxn = @(log_y)  sum(get_residuals(dataTable,logParamsToParams(log_y,1),myModelHandle).^2);

optsLsq = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt');
[log_y_lsq,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,log_y_init,lower_bounds,upper_bounds,optsLsq);
y_lsq = logParamsToParams(log_y_lsq,1);

% optsFmincon = optimoptions('fmincon','Algorithm','sqp','MaxFunctionEvaluations',2e4);
% log_y_fmincon = fmincon(costfxn,log(abs(y_init)),[],[],[],[],lower_bounds,upper_bounds,[],optsFmincon);
% y_fmincon = logParamsToParams(log_y_fmincon,1);

% lsq finds a deeper minimum than fmincon
y = y_lsq;

%%
%mymat = 1:3;
%show_F_vs_x_joint(dataTable,y,myModelHandle,'ShowInterpolatingFunction',true,'MaterialRange',mymat); prettyplot;
%show_F_vs_xc_x_joint(dataTable,y,myModelHandle,'ShowInterpolatingFunction',true,'MaterialRange',mymat); prettyplot;


