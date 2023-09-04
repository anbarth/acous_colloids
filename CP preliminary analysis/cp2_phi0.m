my_cp_data = cp_data_01_18;

phi20 = cp_low_phi(cp_low_phi(:,1)==.2, :);
phi25 = cp_low_phi(cp_low_phi(:,1)==.25, :);
phi30 = cp_low_phi(cp_low_phi(:,1)==.3, :);
phi35 = cp_low_phi(cp_low_phi(:,1)==.35, :);
phi40 = cp_low_phi(cp_low_phi(:,1)==.4, :);
eta_20 = CSV/1000*mean(phi20(:,3));
eta_25 = CSV/1000*mean(phi25(:,3));
eta_30 = CSV/1000*mean(phi30(:,3));
eta_35 = CSV/1000*mean(phi35(1:4,3));
eta_40 = CSV/1000*mean(phi40(1:4,3));


phi44 = my_cp_data(my_cp_data(:,1)==.44 & my_cp_data(:,2)==0, :);
phi48 = my_cp_data(my_cp_data(:,1)==.48 & my_cp_data(:,2)==0, :);
phi50 = my_cp_data(my_cp_data(:,1)==.50 & my_cp_data(:,2)==0, :);
phi54 = my_cp_data(my_cp_data(:,1)==.54 & my_cp_data(:,2)==0, :);

eta_44 = CSV/1000*mean(phi44(1:5,4));
eta_48 = CSV/1000*mean(phi48(1:5,4));
eta_50 = CSV/1000*mean(phi50(1:5,4));
eta_54 = CSV/1000*mean(phi54(1:5,4));
%phi_list = [.2,.25,.3,.35,.4,.44,.48,0.5,.54];
%eta_list = [eta_20,eta_25,eta_30,eta_35,eta_40,eta_44,eta_48,eta_50,eta_54];
phi_list = [.44,.48,.5,.54];
eta_list = [eta_44,eta_48,eta_50,eta_54];
%phi_list = [.2,.3,.35,.4,.44,.48,0.5,.54];
%eta_list = [eta_20,eta_30,eta_35,eta_40,eta_44,eta_48,eta_50,eta_54];


p = polyfit(phi_list,eta_list.^(-1/2),1);
disp(-p(2)/p(1))

figure; hold on;
scatter(phi_list,eta_list.^(-1/2))
plot([.15,.65],p(1)*[.15,.65]+p(2));
xlabel('\phi')
ylabel('\eta^{-1/2} (Pa s)^{-1/2}');