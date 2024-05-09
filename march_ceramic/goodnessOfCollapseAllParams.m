function goodness = goodnessOfCollapseAllParams(stressTable, phi_list, volt_list, paramsVector)

[eta0, phi0, delta, sigmastar, C] = unzipParams(paramsVector,length(phi_list));

f = @(sigma,jj) exp(-sigmastar(jj)./sigma);

x_all = zeros(size(stressTable,1),1);
F_all = zeros(size(stressTable,1),1);

for kk=1:size(stressTable,1)
    phi = stressTable(kk,1);
    sigma = stressTable(kk,2);
    voltage = stressTable(kk,3);
    eta = stressTable(kk,4);
    %ii = find(phi == phi_list);
    jj = find(voltage == volt_list);

    x = C(phi == phi_list,voltage == volt_list)*f(sigma,jj) / (phi0-phi);
    F = eta * (phi0-phi)^2;

    x_all(kk) = x;
    F_all(kk) = F;

end
% 
% x_all = zeros(0,1);
% F_all = zeros(0,1);
% for ii=1:9
%     for jj=1:8
%         voltage = volt_list(jj);
%         phi = phi_list(ii);
%         myData = stressTable( stressTable(:,1)==phi & stressTable(:,3)==voltage,:);
%         sigma = myData(:,2);
%         eta = myData(:,4);
%         x = C(ii,jj)*f(sigma,jj) ./ (-1*phi+phi0);
%         F = eta*(phi0-phi)^2;
% 
%         x_all(end+1:end+length(x)) = x;
%         F_all(end+1:end+length(F)) = F;
% 
%     end
% end

%disp(size(x_all))

Fhat = eta0*(1-x_all).^delta;
goodness = sum( ((Fhat-F_all)./F_all).^2 );

% fitfxn = @(s) s(1)*(xc-x_all).^s(2);
% costfxn = @(s) sum(( (fitfxn(s)-F_all)./F_all ).^2);


end