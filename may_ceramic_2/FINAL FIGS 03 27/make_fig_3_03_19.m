optimize_sigmastarV_03_19;

y = y_fmincon;
myModelHandle = @modelHandpickedSigmastarV_CSV;
dataTable = may_ceramic_09_17;

show_F_vs_x(dataTable,y,myModelHandle); prettyPlot;
% ylim([0.3 1e2]); xlim([1e-20 10]);
myfig = gcf;
myfig.Position=[1015,677,414,323];
ylim([1e-1 2e2])
xlim([1e-21 10])

show_F_vs_x(dataTable,y,myModelHandle); prettyPlot;
myfig = gcf;
myfig.Position=[1543,306,361,323];
ylim([1e-1 2e2])
xlim([1e-2 1.7])

show_F_vs_xc_x(dataTable,y,myModelHandle); prettyPlot;
myfig = gcf;
myfig.Position=[1015,677,414,323];
ylim([1e-1 2e2])

sigmastar = y(6:12);
sigmastar_noV = sigmastar(1)*ones(size(sigmastar));
y_noV = y;
y_noV(6:12) = sigmastar_noV;

show_F_vs_x(dataTable,y_noV,myModelHandle); prettyPlot;
myfig = gcf;
myfig.Position=[1015,677,414,323];
ylim([1e-1 2e2])
xlim([1e-21 10])

show_F_vs_x(dataTable,y_noV,myModelHandle); prettyPlot;
myfig = gcf;
myfig.Position=[1543,306,361,323];
ylim([1e-1 2e2])
xlim([1e-2 1.7])

show_F_vs_xc_x(dataTable,y_noV,myModelHandle); prettyPlot;
myfig = gcf;
myfig.Position=[1015,677,414,323];
ylim([1e-1 2e2])

