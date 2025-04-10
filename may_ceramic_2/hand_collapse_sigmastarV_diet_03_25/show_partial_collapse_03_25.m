%optimize_sigmastarV_03_25;

myModelHandle = @modelHandpickedSigmastarV_CSV;
phiRange = included_phi_indices;
showLines = false;
show_F_vs_x(dataTable,y_lsq,myModelHandle,'PhiRange',phiRange,'ShowLines',showLines,'ShowInterpolatingFunction',true,'ShowErrorBars',false)
prettyPlot;
myfig = gcf;
myfig.Position=[50,50,414,323];
ylim([1e-1 2e2])
xlim([1e-21 10])

%show_F_vs_xc_x(dataTable,y_lsq,myModelHandle,'PhiRange',phiRange,'ShowLines',showLines,'ShowInterpolatingFunction',false,'ShowErrorBars',false)
