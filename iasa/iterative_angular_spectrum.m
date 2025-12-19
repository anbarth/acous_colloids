% set up material properties
p_source_amp = 10;
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

% piezo dimensions
R = 19e-3/2;

% set up grid
Nx = 256; % choose something even pls
Ny = Nx;
lambda = c0/f;
z0 = 4*lambda; % image plane height
L = 6*R; % grid dimensions
dx = L/Nx;
plate_shape = circle_matrix(Nx,Ny,R/dx);

% specify desired pressure field in image plane
mygrad = linspace(-1,1,Nx);
%p_target = repmat(mygrad,Ny,1).*plate_shape;
p_target = xor(circle_matrix(Nx,Ny,5e-3/dx),circle_matrix(Nx,Ny,4.5e-3/dx));
figure; hold on; title('target'); p=pcolor(abs(p_target)); p.EdgeColor="none"; colorbar; axis square;
%return

% calculate initial pressure field in hologram plane
p_source = p_source_amp*plate_shape;
%phat0 = p_source*ones(Nx,Ny);
figure; hold on; title('source'); p=pcolor(abs(p_source)); p.EdgeColor="none"; colorbar; axis square;
%return

deltaPhi0 = zeros(Nx,Ny);
p0 = p_source.*exp(1i*deltaPhi0);

% compute the propagators
%kx_vec = 2*pi/(Nx*dx) * (0:Nx-1);
%ky_vec = 2*pi/(Ny*dx) * (0:Ny-1);
kx_vec = 2*pi/(Nx*dx) * (-Nx/2:(Nx/2-1));
ky_vec = 2*pi/(Ny*dx) * (-Ny/2:(Ny/2-1));

[ky,kx] = meshgrid(ky_vec,kx_vec);
% from hologram to image
Hup = exp(1i*z0*sqrt(k_m^2-kx.^2-ky.^2));
% from image to hologram
Hdown = exp(1i*(-z0)*sqrt(k_m^2-kx.^2-ky.^2));
k_cutoff = pi*2*L/(lambda*sqrt( 1/4*(2*L)^2 + z0^2 ));
% kill off parts of the propagator that exceed the cutoff k
Hup = Hup.*heaviside(k_cutoff-sqrt(kx.^2+ky.^2));
Hdown = Hdown.*heaviside(k_cutoff-sqrt(kx.^2+ky.^2));
% correct for nan values which occur when H=infty and heaviside=0
Hup(isnan(Hup))=0;
Hdown(isnan(Hdown))=0;

for ii=1:5
    % propagate to image plane
    P0 = fft2(p0);
    Pz = P0.*Hup;
    pz = ifft2(Pz);

    %if mod(ii,10)==0
        figure; hold on; title(ii); p=pcolor(abs(pz)); p.EdgeColor="none"; colorbar; axis square;
    %end
    
    % in image plane, set magnitude to target magnitude (leaving the phase alone)
    pz_phase = angle(pz);
    pz_targ = p_target * exp(1i*pz_phase);
    
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
    %alphaT = 4*Zt*Zh^2*Zm ./ (Zh^2*(Zt+Zm)^2 * cos(k_h*T).^2 + (Zh^2+Zt*Zm)^2 * sin(k_h*T).^2 );
    
    % in hologram plane, adjust all amplitudes by transmission coefficient
    %p0 = phat0.*sqrt(alphaT).*exp(1i*deltaPhi);

    % in hologram plane, set magnitude to source magnitude (leaving phase alone)
    p0 = p_source.*exp(1i*deltaPhi);

    %if mod(ii,10)==0
    %    figure; hold on; title(ii); p=pcolor(deltaPhi); p.EdgeColor="none"; colorbar; axis square;
    %end

    % kill off everything outside the transducer area
    % (not necessary, phat0 is already 0s outside transducer)
    %p0 = p0.*plate_shape;
end

% figure; hold on;
% title('p0')
% p=pcolor(abs(p0)); p.EdgeColor="none"; colorbar;
% 
% figure; hold on;
% title('pz')
% p=pcolor(abs(pz)); p.EdgeColor="none"; colorbar;
