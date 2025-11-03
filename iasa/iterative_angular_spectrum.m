% set up parameters
Nx = 100;
Ny = Nx;
p_source = 10;
z0 = 0.5e-3;
L = 20e-3; % [m]
dx = L/Nx;
f = 1.15e6; % [Hz]
c0 = 2000; % glycerol
rho0 = 1260; % glycerol
c_h = 2246; % PLA
rho_h = 1240; % PLA
c_al = 6240; % Al
rho_al = 2700; % Al
k_m = 2*pi*f/c0;
k_h = 2*pi*f/c_h;
Zt = rho_al*c_al;
Zh = rho_h*c_h;
Zm = rho0*c0;
T0 = 1e-3; % [m]

% specify desired pressure field in image plane
plate_shape = circle_matrix(Nx,Ny,9.5e-3/dx);
%mygrad = linspace(-1,1,Nx);
%ptarget = repmat(mygrad,Ny,1).*plate_shape;
ptarget = xor(circle_matrix(Nx,Ny,5e-3/dx),circle_matrix(Nx,Ny,4.5e-3/dx));
%figure; hold on; title('target'); p=pcolor(abs(ptarget)); p.EdgeColor="none"; colorbar; 

% calculate initial pressure field in hologram plane
phat0 = p_source*plate_shape;
%phat0 = p_source*ones(Nx,Ny);

deltaPhi0 = zeros(Nx,Ny);
p0 = phat0.*exp(1i*deltaPhi0);

% compute the propagators
kx_vec = 2*pi/(Nx*dx) * (0:Nx-1);
ky_vec = 2*pi/(Ny*dx) * (0:Ny-1);
[ky,kx] = meshgrid(ky_vec,kx_vec);
% from hologram to image
Hup = exp(1i*z0*sqrt(k_m^2-kx.^2-ky.^2));
% from image to hologram
Hdown = exp(1i*(-z0)*sqrt(k_m^2-kx.^2-ky.^2));

for ii=1:5
    % propagate to image plane
    P0 = fft2(p0);
    Pz = P0.*Hup;
    pz = ifft2(Pz);

    figure; hold on; title(ii); p=pcolor(abs(pz)); p.EdgeColor="none"; colorbar;
    
    % in image plane, set magnitude to target magnitude (leaving the phase alone)
    pz_targ = pz ./ abs(pz) * ptarget;
    
    % propagate back to hologram plane
    Pz = fft2(pz_targ);
    P0 = Pz.*Hdown;
    p0 = ifft2(P0);

    %figure; hold on; title('p0'); p=pcolor(abs(p0)); p.EdgeColor="none"; colorbar;
    
    % using the phase of the back-propagated field, find thickness
    deltaPhi = angle(p0);
    deltaT = deltaPhi/(k_m-k_h);
    T = T0+deltaT;
    
    % from thickness, find transmission coefficient
    alphaT = 4*Zt*Zh^2*Zm ./ (Zh^2*(Zt+Zm)^2 * cos(k_h*T).^2 + (Zh^2+Zt*Zm)^2 * sin(k_h*T).^2 );
    
    % in hologram plane, adjust all amplitudes by transmission coefficient
    p0 = phat0.*alphaT;
end

% figure; hold on;
% title('p0')
% p=pcolor(abs(p0)); p.EdgeColor="none"; colorbar;
% 
% figure; hold on;
% title('pz')
% p=pcolor(abs(pz)); p.EdgeColor="none"; colorbar;
