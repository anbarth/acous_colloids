% data comes as rate, stress, phi
datRaw = readmatrix("chris_pressure_controlled_sims_04_25_2025.csv");

% my table form: phi, stress, V, eta, eta_err
chris_table_04_25 = [datRaw(:,3) datRaw(:,2) zeros(size(datRaw(:,1))) datRaw(:,2)./datRaw(:,1) zeros(size(datRaw(:,1)))];