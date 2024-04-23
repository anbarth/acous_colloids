dataTable = march_data_table_04_23;

%C_init = [0.7 1.3 1.15 0.95 0.8];
%C_init = [0.9 1.2 1.1 0.9 0.8];
C_init = [1 1 1.0902  1.5301   1.3011  1.1  1.0537    0.8429 0.77];
costfxnC = @(myC) goodnessOfCollapseWithC(march_data_table_04_23,myC,0);

opts = optimoptions('fmincon','Display','off');
newC = fmincon(costfxnC,C_init,[],[],[],[],[],[],[],opts);

disp(newC)
