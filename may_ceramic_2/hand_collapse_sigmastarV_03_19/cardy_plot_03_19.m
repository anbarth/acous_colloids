optimize_C_jardy_03_19; y=y_lsq_0V; modelHandle=@modelHandpickedAllExp0V; dataTable = may_ceramic_09_17(may_ceramic_09_17(:,3)==0,:);

interp=true;

A = y(4);
eta0 = y(1);
delta = y(3);
xi0 = (A/eta0)^(1/(-2-delta));

show_collapse_helper(3,dataTable,y,modelHandle,'Alpha',1,'ColorBy',2,'ShowInterpolatingFunction',interp); 
prettyplot
title('\alpha=1')
xline(xi0)
xifake = logspace(-3,6);
%plot(xifake,A*xifake.^delta);
%plot(xifake,eta0*xifake.^(-2));

alpha=0.02;
show_collapse_helper(3,dataTable,y,modelHandle,'Alpha',alpha,'ColorBy',2,'ShowInterpolatingFunction',interp); 
prettyplot
title('\alpha=0.02')
xline(xi0)
%plot(xifake,A*(alpha)^delta*xifake.^delta);
%plot(xifake,eta0*xifake.^(-2));

alpha=0.5;
show_collapse_helper(3,dataTable,y,modelHandle,'Alpha',alpha,'ColorBy',2,'ShowInterpolatingFunction',interp); 
prettyplot
title('\alpha=0.5')
xline(xi0)