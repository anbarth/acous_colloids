function eta = viscosity_prediction(phi,sigma,V,dataTable,y,modelHandle)
if length(sigma) == 1
    sigma = sigma*ones(size(phi));
end
if length(phi)==1
    phi = phi*ones(size(sigma));
end
if length(V)==1
    V = V*ones(size(sigma));
end

% put extra entries in for other volume fractions, otherwise the model gets
% confused over D(phi)
if ~isempty(dataTable)
    phi_list = unique(dataTable(:,1));
    phi_ext = [phi;phi_list];
    sigma_ext = [sigma;zeros(size(phi_list))];
    V_ext = [V;zeros(size(phi_list))];
else
    phi_ext = phi;
    sigma_ext = sigma;
    V_ext = V;
end

fake_eta = zeros(size(sigma_ext));
fake_delta_eta = fake_eta;
fake_data_table = [phi_ext, sigma_ext, V_ext, fake_eta, fake_delta_eta];


[~,~,~,~,~,~,eta_hat] = modelHandle(fake_data_table, y);

% cut out the fake extra entries
eta = eta_hat(1:length(sigma));


end