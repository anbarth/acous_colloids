dataTable = may_table_06_05;

%C_init = [0.7 1.3 1.15 0.95 0.8];
%C_init = [0.9 1.2 1.1 0.9 0.8];
voltnum=1;

C_init = 0.96*[0.01 0.025 0.05 0.1 0.2 0.4 0.85 0.9 1 1 1];
costfxnC = @(myC) goodnessOfCollapseWithC(dataTable,myC,voltnum,0);

opts = optimoptions('fmincon','Display','off');
lb = zeros(size(C_init));
ub = Inf*ones(size(C_init));
newC = fmincon(costfxnC,C_init,[],[],[],[],lb,ub,[],opts);

disp(newC)
