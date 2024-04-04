function plotReversal(rheoData,scaleFactor)
% 0. set up fig
%figure; 
%hold on;
ax1 = gca;
ax1.XScale = 'log';
ax1.YScale = 'log';

% 1. get strain 
strain = getStrain(rheoData);


% 2. get just the data with t > 25s (after training)
%time = getTime(rheoData);
%strain = strain(time > 25);

% 2. get just the data with sigma < 0 (after reversal)
stress = getStress(rheoData,1); % (rheometer units)
strain = strain(stress < 0);

% 3. subtract off the initial value to get delta_strain
delta_strain = -1*(strain - strain(1));

% 3. get viscosity
eta = getViscosity(rheoData,1,2);
eta = eta(stress < 0);

% 4. plot eta vs delta_strain
if nargin < 2
    plot(delta_strain,eta,'LineWidth',1.5);
    ylabel(strcat( '\eta (Pa s)' ));
else
    plot(delta_strain,eta*scaleFactor,'LineWidth',1.5);
    ylabel(strcat( 'rescaled \eta (Pa s)' ));
end
xlabel('strain after reversal');

end