myPhiData = ness_data_table(ness_data_table(:,1)==0.635,:);
show_me = myPhiData(:,2) >= 0.008 & myPhiData(:,2) <= 0.009;

myWeirdData = myPhiData(show_me,:);
