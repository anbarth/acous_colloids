optimize_sigmastarV_03_19;

y = y_fmincon;
myModelHandle = @modelHandpickedSigmastarV_CSV;
dataTable = may_ceramic_09_17;

show_F_vs_x(dataTable,y,myModelHandle); ylim([0.3 1e2]); xlim([1e-20 10]); prettyPlot;
show_F_vs_x(dataTable,y,myModelHandle); ylim([0.3 1e2]); xlim([1e-2 1.5]); prettyPlot;
show_F_vs_xc_x(dataTable,y,myModelHandle,'ColorBy',3,'ShowInterpolatingFunction',true); prettyPlot;
ylim([1e-1 2e2])
xlim([7e-4 1])
yticks([1e-1 1e2])
xticks([1e-3 1e-2 1e-1 1])

sigmastar = y(6:12);
sigmastar_noV = sigmastar(1)*ones(size(sigmastar));
y_noV = y;
y_noV(6:12) = sigmastar_noV;

show_F_vs_x(dataTable,y_noV,myModelHandle); ylim([0.3 1e2]); xlim([1e-20 10]); prettyPlot;
show_F_vs_x(dataTable,y_noV,myModelHandle); ylim([0.3 1e2]); xlim([1e-2 1.5]); prettyPlot;
show_F_vs_xc_x(dataTable,y_noV,myModelHandle,'ColorBy',3); ylim([0.3 1e2]); prettyPlot;