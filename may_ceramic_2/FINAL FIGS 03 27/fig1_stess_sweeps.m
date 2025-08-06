stress_sweeps; % make sure its set to real units and not rheometer units
prettyPlot;
xlim([1e-2 1e4])
ylim([1 2e4])
ylabel('Viscosity \eta (Pa s)')
xlabel('Shear stress \sigma (Pa)')
myfig = gcf;
myfig.Position=[100,100,414,424];
ax1=gca;
ax1.XTick = [1e-2 1 1e2 1e4];
ax1.YTick = [1e0 1e2 1e4];
%cb=colorbar;

