%optimize_C_jardy_02_11;

myModelHandle = @modelHandpickedAllExp0V_CSV;

phiRange = 13:-1:1;
show_F_vs_x(dataTable,y_lsq_0V,myModelHandle,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)
prettyPlot;
xlim([1e-22 10])
show_F_vs_xc_x(dataTable,y_lsq_0V,myModelHandle,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)
prettyPlot;