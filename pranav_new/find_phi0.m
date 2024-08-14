dataTable = pranav_data_table;


phi = [0.44, 0.46, 0.48, 0.5, 0.52, 0.53];
%phi = unique(dataTable(:,1));
eta = zeros(size(phi));
delta_eta = zeros(size(phi));
for ii=1:length(phi)
    myData = dataTable(dataTable(:,1)==phi(ii) & dataTable(:,3)==0, :);
    mySigma = myData(:,2);
    myEta = myData(:,4);
    myDeltaEta = myData(:,5);
    
    % grab eta for lowest sigma
    %[~,lowStressIndex] = min(sigma); 
    
    % actually just grab the value at 0.1pa to avoid low stress weirdness?
    lowStressIndex = find(0.1==mySigma);
    eta(ii) = myEta(lowStressIndex);
    delta_eta(ii) = myDeltaEta(lowStressIndex);
end

figure; hold on;
delta_eta_minushalf = 1/2 * eta.^(-3/2) .* delta_eta;
%errorbar(phi,eta.^(-1/2),delta_eta_minushalf,'o')
plot(phi,eta.^(-1/2),'o')

p = polyfit(phi,eta.^(-1/2),1);
disp(-p(2)/p(1))
disp((-p(1))^-2)
plot([.15,.65],p(1)*[.15,.65]+p(2));
xlabel('\phi')
ylabel('\eta^{-1/2} (Pa s)^{-1/2}');