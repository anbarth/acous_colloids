my_cp_data = cp_data_01_18;
volt_list = [0,5,10,20,40,60,80,100];
phi_list = [44,48,50,54];

figure;
hold on;
ax1 = gca;
ax1.XScale = 'log';
ax1.YScale = 'log';
cmap = viridis(256);
minPhi = min(phi_list);
maxPhi = max(phi_list);

for ii=1:length(volt_list)
    my_V = volt_list(ii);
    my_V_data = my_cp_data(my_cp_data(:,2)==my_V, :);
    phi = my_V_data(:,1);
    sigma = CSS*my_V_data(:,3);
    eta = CSV/1000*my_V_data(:,4);

    myColor = cmap(round(1+255*my_V/100),:);
    for jj=1:length(phi_list)
        myPhi = phi_list(jj)/100;
        myStress=sigma(phi==myPhi);
        myEta=eta(phi==myPhi);
        plot(myStress,myEta,'-o','Color',myColor)
    end
    
end
