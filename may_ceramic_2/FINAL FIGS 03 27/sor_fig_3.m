%optimize_sigmastarV_03_19;

y = y_fmincon;
myModelHandle = @modelHandpickedSigmastarV_CSV;
dataTable = may_ceramic_09_17;

colorBy=3; % 3 for U, 1 for V
interp = false;

show_F_vs_x(dataTable,y,myModelHandle,'ColorBy',colorBy,'ShowInterpolatingFunction',interp); prettyPlot;
% ylim([0.3 1e2]); xlim([1e-20 10]);
myfig = gcf;
myfig.Position=[20,10,414,323];
ylim([1e-1 2e2])
xlim([1e-21 10])
close



show_F_vs_x(dataTable,y,myModelHandle,'ColorBy',colorBy,'ShowInterpolatingFunction',interp); prettyPlot;
myfig = gcf;
myfig.Position=[258.3333333333333,78.33333333333333,417.3333333333333,323.3333333333333];
ylim([1e-1 2e2])
xlim([1e-2 1.7])
xticks([1e-2 1])
yticks([1e-1 1e2])


sigmastar = y(6:12);
sigmastar_noV = sigmastar(1)*ones(size(sigmastar));
y_noV = y;
y_noV(6:12) = sigmastar_noV;

show_F_vs_x(dataTable,y_noV,myModelHandle,'ColorBy',colorBy); prettyPlot;
myfig = gcf;
myfig.Position=[258.3333333333333,78.33333333333333,417.3333333333333,323.3333333333333];
ylim([1e-1 2e2])
xlim([1e-21 10])
close


show_F_vs_x(dataTable,y_noV,myModelHandle,'ColorBy',colorBy); prettyPlot;
myfig = gcf;
myfig.Position=[258.3333333333333,78.33333333333333,417.3333333333333,323.3333333333333];
ylim([1e-1 2e2])
xlim([1e-2 1.7])
xticks([1e-2 1])
yticks([1e-1 1e2])

