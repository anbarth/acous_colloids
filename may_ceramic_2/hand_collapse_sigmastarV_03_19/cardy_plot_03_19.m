optimize_C_jardy_03_19; y=y_lsq_0V; modelHandle=@modelHandpickedAllExp0V; dataTable = may_ceramic_09_17(may_ceramic_09_17(:,3)==0,:);

interp=true;

show_collapse_helper(3,dataTable,y,modelHandle,'Alpha',1,'ColorBy',2,'ShowInterpolatingFunction',interp); 
prettyplot
title('\alpha=1')

show_collapse_helper(3,dataTable,y,modelHandle,'Alpha',0.02,'ColorBy',2,'ShowInterpolatingFunction',interp); 
prettyplot
title('\alpha=0.02')