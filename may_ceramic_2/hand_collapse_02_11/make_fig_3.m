load("optimized_params_02_11.mat")
y = y_fminsearch;
dataTable = may_ceramic_09_17;
myModelHandle = @modelHandpickedAllExp_CSV;

errBars = false;
show_F_vs_x(dataTable,y,myModelHandle,'ShowErrorBars',errBars)
prettyPlot;
xlim([1e-22 10])
ylim([0.2 200])
show_F_vs_xc_x(dataTable,y,myModelHandle,'ShowErrorBars',errBars)
prettyPlot;
ylim([0.2 200])


return
% compare with uncollapsed data?
show_F_vs_x(dataTable,y_lsq_0V,@modelHandpickedAllExp0V_CSV,'ShowErrorBars',errBars)
prettyPlot;
xlim([1e-22 10])
ylim([0.2 200])
show_F_vs_xc_x(dataTable,y_lsq_0V,@modelHandpickedAllExp0V_CSV,'ShowErrorBars',errBars)
prettyPlot;
ylim([0.2 200])

% show_F_vs_x(dataTable,y_lsq_0V,@modelHandpickedAllExp0V_CSV,'ShowErrorBars',true,'ShowLines',true,'PhiRange',10)
% xlim([0.1 1.5])
% ylim([0.3 30])
% prettyPlot;