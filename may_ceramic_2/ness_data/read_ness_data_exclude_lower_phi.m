read_ness_data;
%includeRows = ness_data_table(:,1) < 0.64;
includeRows = ness_data_table(:,1)>=0.55 & ness_data_table(:,1) < 0.64;
ness_data_table = ness_data_table(includeRows,:);