Nx = 100;
Ny = Nx;
p_source = 10;
proj_dist = 0.5e-3;
c0 = 2000;
f0 = 1.15e6;

L = 19e-3; % [m]

dx = L/Nx;

p0 = p_source*ones(Nx,Ny);
p0(:,1:50)=0;
deltaPhi0 = zeros(Nx,Ny);

pressure = angularSpectrumCW(p0.*exp(1i*deltaPhi0), dx, proj_dist, f0, c0);

figure; hold on;
p=pcolor(p0); p.EdgeColor="none"; colorbar;

figure; hold on;
p=pcolor(abs(pressure)); p.EdgeColor="none"; colorbar;