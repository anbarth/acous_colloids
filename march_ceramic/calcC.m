dataTable = march_data_table_04_04;

%C_init = [0.7 1.3 1.15 0.95 0.8];
C_init = [0.9 1.2 1.1 0.9 0.8];
costfxnC = @(myC) goodnessOfCollapseWithC(march_data_table_04_04,myC,0);

opts = optimoptions('fmincon','Display','off');
newC = fmincon(costfxnC,C_init,[],[],[],[],[],[],[],opts);

disp(newC)
