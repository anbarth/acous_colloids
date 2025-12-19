%% create the computational grid
Nx = 128;            % number of grid points in the x direction
Ny = 128;            % number of grid points in the y direction
Nz = 128;            % number of grid points in the z direction
dx = 0.5e-3;        % grid point spacing in the x direction [m]
dy = 0.5e-3;        % grid point spacing in the y direction [m]
dz = 0.5e-3;        % grid point spacing in the z direction [m]
kgrid = kWaveGrid(Nx, dx, Ny, dy, Nz, dz);
source_freq = 1.15e6;   % [Hz]

%% define the properties of the propagation medium
c_glycerol = 1900;
rho_glycerol = 1260;
c_al = 6240;
rho_al = 2700;
c_resin = 1350;
rho_resin = 1100;
c_ureth = 200;
rho_ureth = 1100;

% glycerol medium
medium.sound_speed = c_glycerol * ones(Nx, Ny, Nz);   % [m/s]
medium.density = rho_glycerol * ones(Nx, Ny, Nz);       % [kg/m^3]

% aluminum disk
al_disk_height = 8.1391e-3; % m
al_disk_radius = 2*19/2*10^-3; % m
al_disk_shape = makeDisc(Nx,Ny,Nx/2,Ny/2,round(al_disk_radius/dx));

al_disk_bottom = kgrid.z_vec(1)+22*dz; % m
al_disk_top = al_disk_bottom+al_disk_height;
al_disk_z_indices = find(kgrid.z_vec>al_disk_bottom & kgrid.z_vec<al_disk_top);
for ii=1:length(al_disk_z_indices)
    zz=al_disk_z_indices(ii);
    c_layer = medium.sound_speed(:,:,zz);
    rho_layer = medium.density(:,:,zz);
    c_layer(al_disk_shape==1)=c_al;
    rho_layer(al_disk_shape==1)=rho_al;
    medium.sound_speed(:,:,zz) = c_layer;    
    medium.density(:,:,zz) = rho_layer;         
end



% top plate
top_plate_height = al_disk_top+2e-3;
top_plate_z_indices = find(kgrid.z_vec>top_plate_height);
for ii=1:length(top_plate_z_indices)
    zz=top_plate_z_indices(ii);
    c_layer = medium.sound_speed(:,:,zz);
    rho_layer = medium.density(:,:,zz);
    c_layer(al_disk_shape==1)=c_al;
    rho_layer(al_disk_shape==1)=rho_al;
    medium.sound_speed(:,:,zz) = c_layer;    
    medium.density(:,:,zz) = rho_layer;         
end

unit=1e3;
figure; pcolor(-1*kgrid.x_vec*unit,kgrid.z_vec*unit,rot90(reshape(medium.density(:,Ny/2,:),Nx,Nz),-1)); xlabel('x'); ylabel('z')
figure; pcolor(-1*kgrid.x_vec*unit,kgrid.y_vec*unit,reshape(medium.density(:,:,30),Nx,Nz)); xlabel('x'); ylabel('y')


%% make time array
t_end = 6e-6;
kgrid.makeTime(medium.sound_speed, [], t_end);

%% create transducer source
% create empty array
karray = kWaveArray;

% add linear elements
karray.addDiscElement([kgrid.x_vec(Nx/2), kgrid.y_vec(Ny/2), al_disk_bottom], al_disk_radius*2, [kgrid.x_vec(Nx/2), kgrid.y_vec(Ny/2), al_disk_bottom+2e-3])
source.p_mask = karray.getArrayBinaryMask(kgrid);

% drive sinusoidally
source_mag = 5;         % [Pa]
source_signal_single = source_mag * sin(2 * pi * source_freq * kgrid.t_array);

source.p = karray.getDistributedSourceSignal(kgrid,source_signal_single);




%% define sensor points
sensor_height = al_disk_top + 1e-3; % [m]
[~,sensor_height_px] = min(abs(kgrid.z_vec-sensor_height));
sensor.mask = zeros(Nx, Ny, Nz);
N_sensors = 0;
for ii=35:5:(Nx-35)
    N_sensors=N_sensors+1;
    sensor.mask(ii, Ny/2, sensor_height_px) = 1;
end
%figure; pcolor(-1*kgrid.x_vec*unit,kgrid.z_vec*unit,rot90(reshape(sensor.mask(:,Ny/2,:),Nx,Nz),-1)); xlabel('x'); ylabel('z')
% plot source and sensors
voxelPlot(double(sensor.mask | source.p_mask))

% define the acoustic parameters to record
sensor.record = {'p', 'p_rms'};

%% run!
input_args = {'PlotLayout', true, 'PlotPML', false, ...
    'DataCast', 'single', 'CartInterp', 'nearest'};
sensor_data = kspaceFirstOrder3D(kgrid, medium, source, sensor, input_args{:});

%% plot stuff

% plot the simulated sensor data
[t_sc, scale, prefix] = scaleSI(max(kgrid.t_array(:)));

figure;
imagesc(kgrid.t_array * scale, 1:N_sensors, sensor_data.p);
xlabel(['Time [' prefix 's]']);
ylabel('Detector Number');
colorbar;

figure;
plot(1:N_sensors,sensor_data.p_rms,'kx-')