dataTable = may_ceramic_09_17;
phi_list_full = unique(dataTable(:,1));
volt_list_full = [0 5 10 20 40 60 80];

% restrict what's included in the data table
included_V_indices = [1 3 5 6];
excluded_V_indices = setdiff(1:7,included_V_indices);
included_V = volt_list_full(included_V_indices);
included_phi_indices = 1:13;
excluded_phi_indices = setdiff(1:13,included_phi_indices);
included_phi = phi_list_full(included_phi_indices);

restricted_data_table = zeros(0,5);
for kk=1:size(dataTable,1)
    phi = dataTable(kk,1);
    V = dataTable(kk,3);
    if any(included_V==V) && any(included_phi==phi)
        restricted_data_table(end+1,:) = dataTable(kk,:);
    end
end

% include ghost entries for the excluded volume fractions
% this is important bc several downstream functions assume
% phi_list=unique(column 1)
for ii=excluded_phi_indices
    phi = phi_list_full(ii);
    restricted_data_table(end+1,:) = [phi -1 -1 -1 -1];
end