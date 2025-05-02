dataTable = meera_cs_table;
phi_list_full = unique(dataTable(:,1));
dataTable = dataTable(dataTable(:,1)<=0.54,:);

% initial conditions: meera's collapse parameters
% extracted from spreadsheet
sigmastar = 3.884513;
phi0 = 0.6448091;

% from the sheet Cphi2
C1 = 1/14.5*[0.015927632	0.018405264	0.097091989	0.449867948	0.738476722	0.690197403 ...
    1.09725352	1.434802329	1.901770102	2.192992289	2.439498924	2.409932549	...
    2.348813303	2.394189546	2.31713165	2.191783254	2.170025002	2.096806397	2.052581479...
    1.930983088	1.912993783	1.804182513	1.622650521	1.577736347	1.514463988	1.39644087	...
    1.242312633	1.260424989	1.093716733	0.953947368];
phi_list = unique(dataTable(:,1));
C = C1(ismember(phi_list_full,phi_list));
D = C./(phi0-phi_list');

f=@(sigma,sigmastar) exp(-sigmastar./sigma);
[eta0,sigmastar_WC,phimu,phi0_WC] = wyart_cates(dataTable,f,false);

eta0 = eta0*1.5;
delta = -1.5;
A = eta0;
width = 0.5;
y_init = [eta0 0.65 delta A width sigmastar D];

% check inits before continuing
% log_y_init = log(abs(y_init));
% show_F_vs_x(dataTable,logParamsToParams(log_y_init,3),@modelHandpicked,'ShowInterpolatingFunction',true); prettyplot; xlim([1e-5 1.5])
% show_F_vs_xc_x(dataTable,logParamsToParams(log_y_init,3),@modelHandpicked,'ShowInterpolatingFunction',true); prettyplot;
% return


myModelHandle = @modelHandpicked;
lower_bounds = -Inf*ones(size(y_init));
upper_bounds = Inf*ones(size(y_init));
residualsfxn = @(log_y) get_residuals(dataTable,logParamsToParams(log_y,3),myModelHandle);
costfxn = @(log_y)  sum(get_residuals(dataTable,logParamsToParams(log_y,3),myModelHandle).^2);

optsLsq = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt');
[log_y_lsq,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,log_y_init,lower_bounds,upper_bounds,optsLsq);
y_lsq = logParamsToParams(log_y_lsq,3);

%optsFmincon = optimoptions('fmincon','Algorithm','sqp','MaxFunctionEvaluations',2e4);
%log_y_fmincon = fmincon(costfxn,log(abs(y_init)),[],[],[],[],lower_bounds,upper_bounds,[],optsFmincon);
%y_fmincon = logParamsToParams(log_y_fmincon,3);

% lsq finds a deeper minimum than fmincon
y = y_lsq;
show_F_vs_x(dataTable,y,myModelHandle,'ShowInterpolatingFunction',false); prettyplot; xlim([1e-5 1.5])
show_F_vs_xc_x(dataTable,y,myModelHandle,'ShowInterpolatingFunction',false); prettyplot;


