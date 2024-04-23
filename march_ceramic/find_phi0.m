dataTable = march_data_table_04_04;

%phi = unique(dataTable(:,1));
phi = [0.44, 0.48, 0.56, 0.59];
eta = [];
delta_eta = [];
for ii=1:length(phi)
    
    if phi(ii)==0.52
        continue
    end

    myData = dataTable(dataTable(:,1)==phi(ii) & dataTable(:,3)==0, :);
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

figure; hold on;
delta_eta_minushalf = 1/2 * eta.^(-3/2) .* delta_eta;
errorbar(phi,eta.^(-1/2),delta_eta_minushalf,'o')

p = polyfit(phi,eta.^(-1/2),1);
disp(-p(2)/p(1))
plot([.15,.65],p(1)*[.15,.65]+p(2));
xlabel('\phi')
ylabel('\eta^{-1/2} (Pa s)^{-1/2}');