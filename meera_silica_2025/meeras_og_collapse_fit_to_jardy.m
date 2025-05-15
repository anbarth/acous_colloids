dataTable = meera_cs_table;
phi_list_full = unique(dataTable(:,1));
dataTable = dataTable(dataTable(:,1)<=0.54,:);

f=@(sigma,sigmastar) exp(-sigmastar./sigma);
[eta0,sigmastar_WC,phimu,phi0_WC] = wyart_cates(dataTable,f,false);

eta0 = eta0*1.5;
delta = -1.4;
A = eta0;
width = 1;

myModelHandle = @modelMeeraOriginal;
y_init = [eta0 delta A width];
lower_bounds = -Inf*ones(size(y_init));
upper_bounds = Inf*ones(size(y_init));

% see if init looks reasonable
% show_F_vs_x(dataTable,y_init,myModelHandle,'ShowInterpolatingFunction',true); prettyplot; xlim([1e-5 1.5]);
% show_F_vs_xc_x(dataTable,y_init,myModelHandle,'ShowInterpolatingFunction',true); prettyplot;
% return

residualsfxn = @(y) get_residuals(dataTable,y,myModelHandle);
costfxn = @(y)  sum(get_residuals(dataTable,y,myModelHandle).^2);

optsLsq = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt');
[y_lsq,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_init,lower_bounds,upper_bounds,optsLsq);

% optsFmincon = optimoptions('fmincon','Algorithm','sqp','MaxFunctionEvaluations',2e4);
% y_fmincon = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],optsFmincon);
% fmincon and lsq find the same minimum

show_F_vs_x(dataTable,y_lsq,myModelHandle,'ShowInterpolatingFunction',true); prettyplot; xlim([1e-5 1.5]);
show_F_vs_xc_x(dataTable,y_lsq,myModelHandle,'ShowInterpolatingFunction',true); prettyplot;

confInts = get_conf_ints(dataTable,y_lsq,myModelHandle);

disp('eta0')
disp([y_lsq(1) confInts(1)])
disp('delta')
disp([y_lsq(2) confInts(2)])
disp('A')
disp([y_lsq(3) confInts(3)])
disp('h')
disp([y_lsq(4) confInts(4)])

y=y_lsq;