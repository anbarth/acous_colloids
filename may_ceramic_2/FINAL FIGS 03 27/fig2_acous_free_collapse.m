%optimize_C_jardy_03_19;
phiRange = 13:-1:1;
myModelHandle = @modelHandpickedAllExp0V_CSV;
show_F_vs_x(dataTable,y_lsq_0V,myModelHandle,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true,'ShowErrorBars',true)
prettyPlot;
myfig = gcf;
myfig.Position=[439,383,442,504];
ylim([1e-1 2e2])
xlim([1e-23 10])
yticks([1e-1 1e0 1e1 1e2])
xticks([1e-20  1e-10 1])
ax=gca;ax.TickLength=[.02 .02];


show_F_vs_x(dataTable,y_lsq_0V,myModelHandle,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true,'ShowErrorBars',true)
prettyPlot;
myfig = gcf;
myfig.Position=[1543,306,361,323];
ylim([1e-1 5])
xlim([1e-6 3])

show_F_vs_xc_x(dataTable,y_lsq_0V,myModelHandle,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true,'ShowErrorBars',true)
prettyPlot;
myfig = gcf;
myfig.Position=[1840,673,494,348];
ylim([1e-1 2e2])
xlim([1e-3 1])
yticks([1e-1 1e0 1e1 1e2])
xticks([1e-3 1e-2 1e-1 1])
ax=gca;ax.TickLength=[.02 .02];