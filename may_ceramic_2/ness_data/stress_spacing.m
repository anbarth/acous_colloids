load("ness_data_02_15.mat")
dataTable = ness_data_table_exclude_low_phi;

myPhi = 0.635;
myPhiData = dataTable(dataTable(:,1)==myPhi,:);

figure; hold on; ax1=gca; ax1.YScale='log';
plot(myPhiData(:,2),'o')
xlabel('point no.')
ylabel('shear stress')