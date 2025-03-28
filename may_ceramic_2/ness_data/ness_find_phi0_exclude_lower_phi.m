dataTable = ness_data_table_raw;
dataTable = dataTable(dataTable(:,1)<0.64,:);
phi = unique(dataTable(:,1));

includeIndices = phi>=0.55 & phi<0.64;

eta = [];
delta_eta = [];
for ii=1:length(phi)

    myData = dataTable(dataTable(:,1)==phi(ii) & dataTable(:,3)==0, :);
    mySigma = myData(:,2);
    myEta = myData(:,4);
    myDeltaEta = myData(:,5);
    
    % grab eta for lowest sigma
    %[~,lowStressIndex] = min(sigma); 
    
    % actually just grab the value at 0.03pa to avoid low stress weirdness?
    %lowStressIndex = find(0.02==mySigma | 0.03==mySigma);
    lowStressIndex = find(1e-4==mySigma);
    eta(end+1) = myEta(lowStressIndex);
    delta_eta(end+1) = myDeltaEta(lowStressIndex);
end

% transpose eta
eta = eta';
delta_eta = delta_eta';


figure; hold on;
delta_eta_minushalf = 1/2 * eta.^(-3/2) .* delta_eta;
plot(phi(~includeIndices),eta(~includeIndices).^(-1/2),'o','Color',[0.75 0.75 0.75])
plot(phi(includeIndices),eta(includeIndices).^(-1/2),'ok')
xlabel('\phi')
ylabel('\eta^{-1/2}');

phi=phi(includeIndices);
eta=eta(includeIndices);
delta_eta=delta_eta(includeIndices);

ft1 = fittype('m*(phi0-x)');
opts = fitoptions(ft1);
opts.StartPoint = [16,0.67];
myFit1 = fit(phi,eta.^(-1/2),ft1,opts);
m = myFit1.m;
phi0 = myFit1.phi0;
plot([.48,.66],m*(phi0-[.48,.66]),'r');
yline(0)


ci = confint(myFit1);
phi0_err = (ci(2,2)-ci(1,2))/2;
disp(phi0)
disp(phi0_err)

%myEta = 2.5;
%scatter(0.61,myEta^(-1/2),'rdiamond')

%p = polyfit(phi,eta.^(-1/2),1);
%disp(-p(2)/p(1))
%plot([.15,.65],p(1)*[.15,.65]+p(2));

% eta12 = m*(phi0-phi)
%phi_corrected = phi0-eta.^(-1/2)/m;
%scatter(phi_corrected, eta.^(-1/2),'rd');

%myEta = 2.3;
%myPhiCorrected = phi0-myEta^(-1/2)/m;
%disp(myPhiCorrected);
%scatter(myPhiCorrected,myEta^(-1/2),'rd');

