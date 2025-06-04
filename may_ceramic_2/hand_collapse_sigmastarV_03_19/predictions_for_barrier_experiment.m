fake_sigma = my_stress_list_rheo_units; % from load_old_phi61_data. already in rheo units
fake_phi = 0.6101*ones(size(fake_sigma));

% put extra entries in for other volume fractions, otherwise the model gets
% confused over D(phi)
phi_list = unique(may_ceramic_09_17(:,1));
fake_phi = [fake_phi;phi_list];
fake_sigma = [fake_sigma;zeros(size(phi_list))];

fake_V = zeros(size(fake_sigma));
fake_eta = fake_V;
fake_delta_eta = fake_V;
fake_data_table = [fake_phi, fake_sigma, fake_V, fake_eta, fake_delta_eta];

optimize_C_jardy_03_19;
y_optimal = y_lsq_0V;
modelHandle = @modelHandpickedAllExp0V;
[~,~,~,~,~,~,eta_hat] = modelHandle(fake_data_table, y_optimal);

% cut out the fake extra entries
eta_hat = eta_hat(1:length(my_stress_list_rheo_units));

% no need to fuss with correction factor bc it cancels out here
phi61_rate_hat = my_stress_list_rheo_units./eta_hat;