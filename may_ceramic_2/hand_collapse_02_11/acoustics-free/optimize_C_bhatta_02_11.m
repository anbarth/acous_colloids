play_with_C_02_11;

%myModelHandle = @modelHandpickedAllExp0V;
%y_init = y_handpicked_02_11;
myModelHandle = @modelHandpickedAllExp0VBhatta;
y_init = zeros(1,15);
y_init(1) = y_handpicked_02_11(2); % phi0
y_init(2) = y_handpicked_02_11(6); % sigmastar
y_init(3:end) = y_handpicked_02_11(7:end); % D

acoustics_free_data = dataTable(dataTable(:,3)==0,:);

% check that initial guess looks ok before continuing
%show_F_vs_xc_x(acoustics_free_data,y_init,myModelHandle,'ShowLines',true,'ColorBy',2);
%show_F_vs_x(acoustics_free_data,y_init,myModelHandle,'ShowLines',true,'ColorBy',2);
%return

lower_bounds = -Inf*ones(size(y_init));
upper_bounds = Inf*ones(size(y_init));

costfxnbhatta = @(y) bhattaCostFunction(acoustics_free_data,y,myModelHandle);

%optsFmin = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e5);
%[y_optimal_fmin,fval,exitflag,output,lambda,grad,hessian] = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],optsFmin);
y_bhatta_fmin = fminsearch(costfxnbhatta,y_init);

y_bhatta = y_bhatta_fmin;

Drange = (length(y_bhatta)-numPhi+1):length(y_bhatta);
[x_all,F_all,delta_F_all,~,~,~,~] = myModelHandle(acoustics_free_data, y_bhatta);
old_max_x = max(x_all);
new_max_x = 0.995;
y_bhatta(Drange) = y_bhatta(Drange)*new_max_x/old_max_x;


%phiRange = 13:-1:1;
%show_F_vs_x(dataTable,y_bhatta,myModelHandle,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true,'ShowErrorBars',true)
%show_F_vs_xc_x(dataTable,y_bhatta,myModelHandle,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true,'ShowErrorBars',true)

%disp(costfxnbhatta(y_init))
%disp(costfxnbhatta(y_bhatta))


show_F_vs_xc_x(acoustics_free_data,y_handpicked_02_11,@modelHandpickedAllExp0V,'ColorBy',2,'ShowLines',true,'ShowErrorBars',true)
show_F_vs_xc_x(acoustics_free_data,y_fmincon_0V,@modelHandpickedAllExp0V,'ColorBy',2,'ShowLines',true,'ShowErrorBars',true)
show_F_vs_xc_x(acoustics_free_data,y_bhatta,@modelHandpickedAllExp0VBhatta,'ColorBy',2,'ShowLines',true,'ShowErrorBars',true)

disp(bhattaCostFunction(acoustics_free_data,y_handpicked_02_11,@modelHandpickedAllExp0V));
disp(bhattaCostFunction(acoustics_free_data,y_fmincon_0V,@modelHandpickedAllExp0V));
disp(bhattaCostFunction(acoustics_free_data,y_bhatta,@modelHandpickedAllExp0VBhatta));