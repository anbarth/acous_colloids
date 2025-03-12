load("optimized_params_02_11.mat");

show_F_vs_x(may_ceramic_09_17,y_fminsearch,@modelHandpickedAllExp_CSV,'VoltRange',1:4)
prettyPlot;
xlim([1e-31 10])
ylim([0.3 1e2])

% show_F_vs_xc_x(may_ceramic_09_17,y_fminsearch,@modelHandpickedAllExp_CSV,'VoltRange',1:5)
% prettyPlot;

%optimize_C_jardy_02_11;
% show_F_vs_x(may_ceramic_09_17,y_lsq_0V,@modelHandpickedAllExp0V_CSV,'VoltRange',1:4)
% prettyPlot;
% xlim([1e-31 10])
% ylim([0.3 1e2])

