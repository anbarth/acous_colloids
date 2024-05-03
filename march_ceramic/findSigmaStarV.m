dataTable = march_data_table_05_02;
volt_list = [0,5,10,20,40,60,80,100];
my_sigmastar_V = zeros(1,8);

for ii=1:length(volt_list)
    my_sigmastar_V(ii) = findSigmaStarWC(dataTable,volt_list(ii),false);
end

disp(my_sigmastar_V)

figure; hold on;
plot(volt_list,my_sigmastar_V,'--o');
ax1 = gca;
ax1.YScale = 'log';