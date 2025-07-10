optimize_C_jardy_03_19;
phiRange = 13:-1:1;
myModelHandle = @modelHandpickedAllExp0V_CSV;


d1 = 0.75;
d2 = 0.75;
a = 100;
A1 = 0.5;
A2 = 0.5*a^2;
F_power = @(x) A1*(1-x).^(-d1);
F_power_jim = @(x) A2*(1-x).^(-d2)./(x+a).^2;

x_pts = logspace(-20,-1,1000);
x_pts = [x_pts linspace(0.101,0.9999)];
F_power_pts = F_power(x_pts);
F_power_jim_pts = F_power_jim(x_pts);

show_F_vs_x(dataTable,y_lsq_0V,myModelHandle,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)
prettyPlot;
myfig = gcf;
myfig.Position=[1015,677,414,323];
ylim([1e-1 2e2])
xlim([1e-23 10])
%plot(x_pts,F_power_pts,'r-')
plot(x_pts,F_power_jim_pts,'k-')

show_F_vs_x(dataTable,y_lsq_0V,myModelHandle,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)
prettyPlot;
myfig = gcf;
myfig.Position=[1543,306,361,323];
ylim([1e-1 2e2])
xlim([1e-2 1.7])
%plot(x_pts,F_power_pts,'r-')
plot(x_pts,F_power_jim_pts,'k-')

show_F_vs_xc_x(dataTable,y_lsq_0V,myModelHandle,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)
prettyPlot;
myfig = gcf;
myfig.Position=[1015,677,414,323];
ylim([1e-1 2e2])
%plot(1-x_pts,F_power_pts,'r-')
plot(1-x_pts,F_power_jim_pts,'k-')