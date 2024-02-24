dataTable = ceramic_data_table_02_24;

phi = unique(dataTable(:,1));
eta = zeros(size(phi));
for ii=1:length(phi)
    myData = dataTable(dataTable(:,1)==phi(ii) & dataTable(:,3)==0, :);
    mySigma = myData(:,2);
    myEta = myData(:,4);
    
    % grab eta for lowest sigma
    %[~,lowStressIndex] = min(sigma); 
    
    % actually just grab the value at 0.1pa to avoid low stress weirdness?
    lowStressIndex = find(0.1==mySigma);
    eta(ii) = myEta(lowStressIndex);
end

figure; hold on;
plot(phi,eta.^(-1/2),'o')

p = polyfit(phi,eta.^(-1/2),1);
disp(-p(2)/p(1))
plot([.15,.65],p(1)*[.15,.65]+p(2));
xlabel('\phi')
ylabel('\eta^{-1/2} (Pa s)^{-1/2}');