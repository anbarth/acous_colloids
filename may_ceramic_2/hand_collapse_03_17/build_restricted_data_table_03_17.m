dataTable = may_ceramic_09_17;
phi_list = unique(dataTable(:,1));
volt_list = [0 5 10 20 40 60 80];

% restrict what's included in the data table
volts_to_include_indices = [1 3 5 6];
volts_to_exclude_indices = setdiff(1:7,volts_to_include_indices);
volts_to_include = volt_list(volts_to_include_indices);
acoustic_vol_frac_indices = [6 8 10 12];
no_acoustic_vol_frac_indices = setdiff(1:13,acoustic_vol_frac_indices);
acoustic_vol_fracs = phi_list(acoustic_vol_frac_indices);
restricted_data_table = zeros(0,5);
for kk=1:size(dataTable,1)
    phi = dataTable(kk,1);
    V = dataTable(kk,3);
    if any(volts_to_include==V)
        if V==0 || any(acoustic_vol_fracs==phi)
            restricted_data_table(end+1,:) = dataTable(kk,:);
        end
    end
end