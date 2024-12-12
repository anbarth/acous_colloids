
phi = [0.4398
    0.4800
    0.5404
    0.5597
    0.5907
    0.5956];

low_stress_experiments = {phi44_03_19.sig003;phi48_03_25.sig003_100V;...
    phi54_04_17.sig003_100V;phi56_03_28.sig003_100V;...
    phi59_03_20.sig003;phi59p5_04_16.sig003_100V_40V};

time_windows = [33 38
    36.25 41
    48.5 53
    52.5 57.5
    34.5 43.25
    42.25 47.5];

eta = [];
delta_eta = [];
for ii=1:length(low_stress_experiments)
    rheoStruct = low_stress_experiments{ii};
    t = getTime(rheoStruct);
    etaSeries = getViscosity(rheoStruct);

    tStart = time_windows(ii,1);
    tEnd = time_windows(ii,2);
    eta_dethickened = etaSeries(t>tStart & t<tEnd);
    
    myEta = mean(eta_dethickened);
    myDeltaEtaRheo = max(std(eta_dethickened),0.05*myEta);
    deltaPhi = 0.05; % basically made up yikes
    myDeltaEta = sqrt(myDeltaEtaRheo^2 + (myEta*2*(0.7-phi(ii))^-1 * deltaPhi)^2 );

    eta(end+1) = myEta;
    delta_eta(end+1) = myDeltaEta;
end

% transpose eta
eta = eta';
delta_eta = delta_eta';

%figure;
hold on;
delta_eta_minushalf = 1/2 * eta.^(-3/2) .* delta_eta;
errorbar(phi,eta.^(-1/2),delta_eta_minushalf,'r.')
xlabel('\phi')
ylabel('\eta^{-1/2} (Pa s)^{-1/2}');

ft1 = fittype('m*(phi0-x)');
opts = fitoptions(ft1);
opts.StartPoint = [16,0.67];
myFit1 = fit(phi,eta.^(-1/2),ft1,opts);
m = myFit1.m;
phi0 = myFit1.phi0;
plot([.15,.68],m*(phi0-[.15,.68]),'r');


ci = confint(myFit1);
phi0_err = (ci(2,2)-ci(1,2))/2;
disp(phi0)
disp(phi0_err)