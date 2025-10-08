%% create the computational grid
Nx = 128;           % number of grid points in the x (row) direction
Ny = 128;           % number of grid points in the y (column) direction
dx = 0.2e-3;        % grid point spacing in the x direction [m]
dy = 0.2e-3;        % grid point spacing in the y direction [m]
kgrid = kWaveGrid(Nx, dx, Ny, dy);

%% define the properties of the propagation medium
% glycerol medium
medium.sound_speed = 1900 * ones(Nx, Ny);   % [m/s]
medium.density = 1260 * ones(Nx, Ny);       % [kg/m^3]

% aluminum disk
al_disk_height = 8e-3; % m
al_disk_bottom = kgrid.x_vec(end)-22*dx; % m
al_disk_top = al_disk_bottom-al_disk_height;
medium.sound_speed(kgrid.x_vec>al_disk_top, :) = 6240;       % [m/s]
medium.density(kgrid.x_vec>al_disk_top, :) = 2700;          % [kg/m^3]

% create the time array
t_end = 10e-6;
kgrid.makeTime(medium.sound_speed, [], t_end);

%% create transducer source
% create empty array
karray = kWaveArray;
% add linear element
karray.addLineElement([al_disk_bottom,kgrid.y_vec(35)],[al_disk_bottom,kgrid.y_vec(end-34)])
source.p_mask = karray.getArrayBinaryMask(kgrid);
% drive sinusoidally
source_freq = 1.15e6;   % [Hz]
source_mag = 2;         % [Pa]
source_signal = source_mag * sin(2 * pi * source_freq * kgrid.t_array);
%source_signal = filterTimeSeries(kgrid, medium, source_signal);
source.p = karray.getDistributedSourceSignal(kgrid,source_signal);


%% define sensor points
sensor_height = al_disk_top - 0.2e-3; % [m]
[~,sensor_height_px] = min(abs(kgrid.x_vec-sensor_height));
sensor.mask = zeros(Nx, Ny);
sensor.mask(sensor_height_px, Ny/4) = 1;
sensor.mask(sensor_height_px, Ny/2) = 1;
sensor.mask(sensor_height_px, 3*Ny/4) = 1;

% define the acoustic parameters to record
sensor.record = {'p', 'p_final'};

%% visualize to ensure no overlap with PML
% create pml mask (default size in 2D is 20 grid points)
pml_size = 20;
pml_mask = false(Nx, Ny);
pml_mask(1:pml_size, :) = 1;
pml_mask(:, 1:pml_size) = 1;
pml_mask(end - pml_size + 1:end, :) = 1;
pml_mask(:, end - pml_size + 1:end) = 1;

% plot source and pml masks
figure;
imagesc(kgrid.y_vec, kgrid.x_vec, source.p_mask | pml_mask);
%imagesc(kgrid.y_vec, kgrid.x_vec, sensor.mask | pml_mask);
axis image;
colormap(flipud(gray));

% overlay the physical source positions
%hold on;
%karray.plotArray(false);


%% run the simulation
sensor_data = kspaceFirstOrder2D(kgrid, medium, source, sensor, ...
    'PlotLayout', false, 'PlotPML', false);

%% plot stuff
% plot the final wave-field
figure;
imagesc(kgrid.y_vec * 1e3, kgrid.x_vec * 1e3, ...
    sensor_data.p_final + source.p_mask + sensor.mask, [-1, 1]);
colormap(getColorMap);
ylabel('x-position [mm]');
xlabel('y-position [mm]');
axis image;

% plot the simulated sensor data
figure;
[t_sc, scale, prefix] = scaleSI(max(kgrid.t_array(:)));

subplot(2, 1, 1);
mySrcIndex = 100; % plot driving for a random pt in the middle of the source
plot(kgrid.t_array * scale, source.p, 'k-');
hold on; plot(kgrid.t_array * scale, source_signal, 'r-');
xlabel(['Time [' prefix 's]']);
ylabel('Signal Amplitude');
axis tight;
title('Input Pressure Signal');

subplot(2, 1, 2);
plot(kgrid.t_array * scale, sensor_data.p);
xlabel(['Time [' prefix 's]']);
ylabel('Signal Amplitude');
axis tight;
title('Sensor Pressure Signal');
