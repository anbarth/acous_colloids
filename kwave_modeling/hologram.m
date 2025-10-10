%% create the computational grid
Nx = 256;           % number of grid points in the x (row) direction
Ny = 256;           % number of grid points in the y (column) direction
dx = 0.1e-3;        % grid point spacing in the x direction [m]
dy = 0.1e-3;        % grid point spacing in the y direction [m]
kgrid = kWaveGrid(Nx, dx, Ny, dy);

source_freq = 1.15e6;   % [Hz]

%% define the properties of the propagation medium
c_glycerol = 1900;
rho_glycerol = 1260;
c_al = 6240;
rho_al = 2700;
c_PLA = 2000;
rho_PLA = 1200;
c_PDMS = 1030;
rho_PDMS = 1030;

% glycerol medium
medium.sound_speed = c_glycerol * ones(Nx, Ny);   % [m/s]
medium.density = rho_glycerol * ones(Nx, Ny);       % [kg/m^3]

% aluminum disk
lambda_al = c_al/source_freq;
al_disk_height = 1.5*lambda_al; 
al_disk_bottom = kgrid.x_vec(end)-22*dx; 
al_disk_top = al_disk_bottom-al_disk_height;
medium.sound_speed(kgrid.x_vec>al_disk_top, :) = 6240;       % [m/s]
medium.density(kgrid.x_vec>al_disk_top, :) = 2700;          % [kg/m^3]


% hologram
lambda_PLA = c_PLA/source_freq;
hologram_height = lambda_PLA; % m
hologram_bot = al_disk_top;
hologram_top = hologram_bot-hologram_height;
medium.sound_speed(kgrid.x_vec>hologram_top & kgrid.x_vec<hologram_bot,:) = c_PDMS;
medium.density(kgrid.x_vec>hologram_top & kgrid.x_vec<hologram_bot,:) = rho_PDMS;


lambda_PDMS = c_PDMS/source_freq;
cutout_depth = 3*lambda_PDMS/2;
theta = linspace(0,8*pi,Ny);
profile = (hologram_top+cutout_depth/2)+square(theta)*cutout_depth/2;
%profile = (hologram_bot-hologram_height/2)*ones(Ny,1);

for ii=1:length(kgrid.y_vec)
    x_indices = kgrid.x_vec > profile(ii) & kgrid.x_vec < hologram_bot;
    medium.sound_speed(x_indices, ii) = c_PLA;
    medium.density(x_indices, ii) = rho_PLA;
end


% top plate
top_plate_height = hologram_top-2e-3;
medium.sound_speed(kgrid.x_vec<top_plate_height, :) = c_al;       % [m/s]
medium.density(kgrid.x_vec<top_plate_height, :) = rho_al;          % [kg/m^3]


figure; hold on;
p=pcolor(1*kgrid.y_vec,-1*kgrid.x_vec,medium.density); p.EdgeColor="none"; colorbar;
plot(kgrid.y_vec,-1*profile,'k--','LineWidth',1)
yline(-1*hologram_bot,'k')
yline(-1*hologram_top,'k')
%return

% create the time array
t_end = 10e-6;
kgrid.makeTime(medium.sound_speed, [], t_end);

%% create transducer source
% create empty array
karray = kWaveArray;

% add linear elements
left_edge = kgrid.y_vec(35);
right_edge = kgrid.y_vec(end-34);
karray.addLineElement([al_disk_bottom,left_edge],[al_disk_bottom,right_edge])
source.p_mask = karray.getArrayBinaryMask(kgrid);

% drive sinusoidally
source_mag = 5;         % [Pa]
source_signal_single = source_mag * sin(2 * pi * source_freq * kgrid.t_array);

source.p = karray.getDistributedSourceSignal(kgrid,source_signal_single);


%% define sensor points
sensor_height = (hologram_top+top_plate_height)/2; % [m]
[~,sensor_height_px] = min(abs(kgrid.x_vec-sensor_height));
sensor.mask = zeros(Nx, Ny);
N_sensors = 0;
for ii=35:5:(Ny-35)
    N_sensors=N_sensors+1;
    sensor.mask(sensor_height_px, ii) = 1;
end

% define the acoustic parameters to record
sensor.record = {'p', 'p_rms', 'p_final'};

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
input_args = {'RecordMovie', true, 'MovieName', 'plastic_attachment', 'MovieProfile', 'MPEG-4'};
sensor_data = kspaceFirstOrder2D(kgrid, medium, source, sensor, input_args{:});

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

[t_sc, scale, prefix] = scaleSI(max(kgrid.t_array(:)));
% figure;
% subplot(2, 1, 1);
% hold on; plot(kgrid.t_array * scale, source_signal, 'r-');
% xlabel(['Time [' prefix 's]']);
% ylabel('Signal Amplitude');
% axis tight;
% title('Input Pressure Signal');
% subplot(2, 1, 2);
% plot(kgrid.t_array * scale, sensor_data.p);
% xlabel(['Time [' prefix 's]']);
% ylabel('Signal Amplitude');
% axis tight;
% title('Sensor Pressure Signal');

figure;
imagesc(kgrid.t_array * scale, 1:N_sensors, sensor_data.p);
xlabel(['Time [' prefix 's]']);
ylabel('Detector Number');
colorbar;

figure;
plot(1:N_sensors,sensor_data.p_rms,'kx-')