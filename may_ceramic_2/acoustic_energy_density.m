function E0 = acoustic_energy_density(V)
% E0 given in Pa

% constants (SI units)
d33 = 300e-12;
rho = 1200;
c = 2000;
f = 1.15e6; % Hz
k = 2*pi*f/c;

E0 = (rho*c^2*k*V*d33).^2 ./ (2*rho*c^2);

end