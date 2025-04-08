stress_sweeps; % make sure its set to real units and not rheometer units
prettyPlot;
xlim([1e-2 1e4])
ylim([1 2e4])
ylabel('Viscosity \eta (Pa s)')
xlabel('Shear stress \sigma (Pa)')
myfig = gcf;
myfig.Position=[1015,677,414,323];
%cb=colorbar;

