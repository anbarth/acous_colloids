dataTable = march_data_table_05_02;

%C_init = [0.7 1.3 1.15 0.95 0.8];
%C_init = [0.9 1.2 1.1 0.9 0.8];
C_init = 1.1*[0.0800   0.1073    0.8722    1.2241    1.0409    0.8800    0.8430    0.6743    0.6160];
costfxnC = @(myC) goodnessOfCollapseWithC(march_data_table_04_23,myC,0);

opts = optimoptions('fmincon','Display','off');
newC = fmincon(costfxnC,C_init,[],[],[],[],[],[],[],opts);

disp(newC)
