% set up parameters
Nx = 10;
Ny = Nx;
p_source = 10;
z0 = 0.5e-3;
c0 = 2000;
L = 19e-3; % [m]
dx = L/Nx;
f = 1.15e6; % [Hz]
k = 2*pi*f/c0;

% specify desired pressure field
ptarget = ones(Nx,Ny);

% calculate initial pressure field in hologram plane
phat0 = p_source*ones(Nx,Ny);
phat0(:,1:5)=-10;
deltaPhi0 = zeros(Nx,Ny);
p0 = phat0.*exp(1i*deltaPhi0);

% compute the propagator H
kx_vec = 2*pi/(Nx*dx) * (0:Nx-1);
ky_vec = 2*pi/(Ny*dx) * (0:Ny-1);
[ky,kx] = meshgrid(ky_vec,kx_vec);
H = exp(1i*z0*sqrt(k^2-kx.^2-ky.^2));

% propagate to image plane
P0 = fft2(p0);
Pz = P0.*H;
pz = ifft2(Pz);

figure; hold on;
title('p0')
p=pcolor(real(p0)); p.EdgeColor="none"; colorbar;

figure; hold on;
title('pz')
p=pcolor(real(pz)); p.EdgeColor="none"; colorbar;
