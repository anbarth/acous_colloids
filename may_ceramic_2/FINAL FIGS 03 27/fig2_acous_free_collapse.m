optimize_C_jardy_03_19;
phiRange = 13:-1:1;
myModelHandle = @modelHandpickedAllExp0V_CSV;
show_F_vs_x(dataTable,y_lsq_0V,myModelHandle,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)
prettyPlot;
myfig = gcf;
myfig.Position=[1015,677,414,323];
ylim([1e-1 2e2])
xlim([1e-23 10])

show_F_vs_x(dataTable,y_lsq_0V,myModelHandle,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)
prettyPlot;
myfig = gcf;
myfig.Position=[1543,306,361,323];
ylim([1e-1 2e2])
xlim([1e-2 1.7])

show_F_vs_xc_x(dataTable,y_lsq_0V,myModelHandle,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)
prettyPlot;
myfig = gcf;
myfig.Position=[1015,677,414,323];
ylim([1e-1 2e2])