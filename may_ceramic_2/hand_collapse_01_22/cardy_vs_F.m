%calcCollapse_acous_free_01_22;
paramsVector = y_optimal;
myX=0.688477;
show_F_vs_xc_x(dataTable,y_optimal,@modelHandpicked0V,'PhiRange',13:-1:1,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)
xline(1-myX)
show_F_vs_x(dataTable,y_optimal,@modelHandpicked0V,'PhiRange',13:-1:1,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)
xline(myX)
show_cardy(dataTable,y_optimal,@modelHandpicked0V,'alpha',0.002,'PhiRange',1:13,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)
xline(myX^(-1/0.002)-1)
%show_cardy(dataTable,y_optimal,@modelHandpicked0V,'alpha',1,'PhiRange',1:13,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)