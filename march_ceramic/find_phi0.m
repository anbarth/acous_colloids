
dataTable = march_data_table_05_09;

phi = unique(dataTable(:,1));
phi = phi(abs(phi-0.52)>0.001); % exclude 52% because of motor adjustment


eta = [];
delta_eta = [];
for ii=1:length(phi)

    myData = dataTable(abs(dataTable(:,1)-phi(ii))<0.001 & dataTable(:,3)==0, :);
    mySigma = myData(:,2);
    myEta = myData(:,4);
    myDeltaEta = myData(:,5);
    
    % grab eta for lowest sigma
    %[~,lowStressIndex] = min(sigma); 
    
    % actually just grab the value at 0.03pa to avoid low stress weirdness?
    lowStressIndex = find(0.03==mySigma);
    eta(end+1) = myEta(lowStressIndex);
    delta_eta(end+1) = myDeltaEta(lowStressIndex);
end

% transpose eta
eta = eta';
delta_eta = delta_eta';

figure; hold on;
delta_eta_minushalf = 1/2 * eta.^(-3/2) .* delta_eta;
errorbar(phi,eta.^(-1/2),delta_eta_minushalf,'o')
xlabel('\phi')
ylabel('\eta^{-1/2} (Pa s)^{-1/2}');

ft1 = fittype('m*(phi0-x)');
opts = fitoptions(ft1);
opts.StartPoint = [16,0.67];
myFit1 = fit(phi,eta.^(-1/2),ft1,opts);
m = myFit1.m;
phi0 = myFit1.phi0;
plot([.15,.68],m*(phi0-[.15,.68]));


ci = confint(myFit1);
phi0_err = (ci(2,2)-ci(1,2))/2;
disp(phi0)
disp(phi0_err)



%p = polyfit(phi,eta.^(-1/2),1);
%disp(-p(2)/p(1))
%plot([.15,.65],p(1)*[.15,.65]+p(2));
