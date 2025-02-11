play_with_C_02_11;
y_init = y_handpicked_02_11;
%log_y_init = log(abs(y_init));
myModelHandle = @modelHandpickedAllExp;

acoustics_free_data = dataTable(dataTable(:,3)==0,:);

% check that initial guess looks ok before continuing
%show_F_vs_xc_x(acoustics_free_data,y_init,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',2);
%show_F_vs_x(acoustics_free_data,y_init,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',2);
%return

lower_bounds = -Inf*ones(size(y_init));
upper_bounds = Inf*ones(size(y_init));

%costfxn = @(y) bhattaCostFunction(dataTable,y,myModelHandle);
costfxn = @(y)  sum(get_residuals(acoustics_free_data,y,myModelHandle).^2);

%optsFmin = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e5);
%[y_optimal_fmin,fval,exitflag,output,lambda,grad,hessian] = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],optsFmin);
optsFminsearch = optimset('MaxFunEvals',3e6,'MaxIter',3e6);
y_optimal_fmin = fminsearch(costfxn,y_init,optsFminsearch);

%return

phiRange = 13:-1:1;
show_F_vs_x(dataTable,y_optimal_fmin,myModelHandle,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true,'ShowErrorBars',true)
show_F_vs_xc_x(dataTable,y_optimal_fmin,myModelHandle,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true,'ShowErrorBars',true)

disp(costfxn(y_init))
disp(costfxn(y_optimal_fmin))

[eta0, phi0, delta, A, width, sigmastar, D_init, phi_fudge] = unzipParamsHandpickedAll(y_init,13);
[eta0, phi0, delta, A, width, sigmastar, D_optimal_jardy, phi_fudge] = unzipParamsHandpickedAll(y_optimal_fmin,13);

figure; hold on;
makeAxesLogLog;
plot(phi0-phi_list,D_init(:,1),'ok-');
plot(phi0-phi_list,D_optimal_jardy(:,1),'or-');