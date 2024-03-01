phi_list = [59,56,52,48,44,40];
c_list=[3.41,5.61,12.8,20.6,38.9,58.8];
d_list=[0.998,0.88,0.653,0.612,0.618,0.678];



p_c = polyfit(phi_list,c_list,2);
p_c2 = polyfit(68-phi_list,c_list,2);

figure; hold on;
plot(phi_list,c_list,'o')
plot(phi_list,p_c(1)*phi_list.^2+p_c(2)*phi_list+p_c(3))
xlabel('\phi')
ylabel('c')

p_d = polyfit(phi_list,d_list,2);
figure; hold on;
plot(phi_list,d_list,'o')
plot(phi_list,p_d(1)*phi_list.^2+p_d(2)*phi_list+p_d(3))
xlabel('\phi')
ylabel('d')