phisToInclude = [0.2,0.25,0.3,0.35,0.4,0.44,0.46,0.48,0.5,0.52,0.53,0.54,0.55];
%phisToInclude = [0.44,0.46,0.48,0.5,0.52,0.53,0.54,0.55];

% dont change these
phi = [0.2,0.25,0.3,0.35,0.4,0.44,0.46,0.48,0.5,0.52,0.53,0.54,0.55];
eta = zeros(size(phi));

% first, low-phi stuff
load('low_phi_stress_sweeps.mat');
sweeps = {stress_sweep_phi_020,stress_sweep_phi_025,stress_sweep_phi_030,...
    stress_sweep_phi_035,stress_sweep_phi_040};
for ii=1:length(sweeps)
    stress_sweep = sweeps{ii};
    % at these low vol fracs, there's a fake shear-thickening part at the
    % beginning, so the most appropriate viscosity to use as the
    % "low-stress" viscosity is the last value we read
    myEta = CSV*stress_sweep(:,4);
    eta(ii) = myEta(end);
    %eta(ii) = min(myEta);
end

% now, high phi stuff
high_phis = [44,46,48,50,52,53,54,55];
for ii = 1:length(high_phis)
    matFileName = strcat('phi_0',num2str(high_phis(ii)),'.mat');
    load(matFileName);
    myEta = CSV*stress_sweep_trimmed(:,4);
    eta(5+ii) = min(myEta); % if including small phi
end

include_me = false(length(phi),1);
for ii=1:length(phi)
    if any(phisToInclude==phi(ii))
        include_me(ii) = true;
    end
end
phi = phi(include_me);
eta = eta(include_me);

%figure; hold on;
scatter(phi,1./sqrt(eta),'d');
P = polyfit(phi,1./sqrt(eta),1);
sqrtEtaFit = P(1)*phi+P(2);
%plot(phi,sqrtEtaFit);

xlabel('\phi')
ylabel('\eta^{-1/2}')

disp(-1*P(2)/P(1));
