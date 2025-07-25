%optimize_C_jardy_03_19;
y = y_lsq_0V;

show_F_vs_x(acoustics_free_data,y,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',2,'ShowLines',false)
xlim([1e-5 1.5]); xticks([1e-5 1])
prettyPlot
f1=gcf; f1.Position=[1087,375,499,483];

show_cardy(acoustics_free_data,y,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',2,'ShowLines',false)
xlim([1e-3 1e5]); xticks([1e-3 1e1 1e5]); yticks([1e-10 1e0 ])
ylim([1e-12 1e1]);
prettyPlot
f1=gcf; f1.Position=[1087,375,499,483];

% xifake = logspace(-3,5,2);
% F0 = y(1);
% A = y(4);
% delta = y(3);
% hold on
% plot(xifake,A*xifake.^delta,'k--')
% plot(xifake,F0*xifake.^-2,'k--')