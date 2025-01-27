play_with_C_01_22;
y_init = y_handpicked_01_22;
%log_y_init = log(abs(y_init));
myModelHandle = @modelHandpicked0V;

acoustics_free_data = dataTable(dataTable(:,3)==0,:);

% check that initial guess looks ok before continuing
%show_F_vs_xc_x(dataTable,y_init,myModelHandle,'ShowInterpolatingFunction',false,'ColorBy',2);
%return

lower_bounds = -Inf*ones(size(y_init));
upper_bounds = Inf*ones(size(y_init));

%costfxn = @(y) bhattaCostFunction(dataTable,y,@modelHandpicked0V);
costfxn = @(y)  sum(get_residuals(acoustics_free_data,y,myModelHandle).^2);

%optsFmin = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e5);
%[y_optimal_fmin,fval,exitflag,output,lambda,grad,hessian] = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],optsFmin);
y_optimal_fmin = fminsearch(costfxn,y_init);

phiRange = 13:-1:1;
show_F_vs_x(dataTable,y_optimal_fmin,@modelHandpicked0V,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true,'ShowErrorBars',true)
show_F_vs_xc_x(dataTable,y_optimal_fmin,@modelHandpicked0V,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true,'ShowErrorBars',true)
