read_ness_data;
includeRows = ness_data_table(:,1)>=0.55 & ness_data_table(:,1) < 0.64;
ness_data_table_exclude_low_phi = ness_data_table(includeRows,:);