Nx = 100;
Ny = Nx;
p_source = 10;
proj_dist = 0.5e-3;
c0 = 2000;

L = 19e-3; % [m]

dx = L/Nx;

p0 = p_source*ones(Nx,Ny);
p0(:,1:50)=0;
deltaPhi0 = zeros(Nx,Ny);

[~, plane_2_as] = angularSpectrum(p0.*exp(1i*deltaPhi0), dx, 1, proj_dist, c0);

figure; hold on;
p=pcolor(p0); p.EdgeColor="none"; colorbar;

figure; hold on;
p=pcolor(plane_2_as); p.EdgeColor="none"; colorbar;