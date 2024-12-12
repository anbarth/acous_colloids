dataTable = may_ceramic_06_05;

%C_init = [0.7 1.3 1.15 0.95 0.8];
%C_init = [0.9 1.2 1.1 0.9 0.8];
voltnum=7;

C_init = 0.96*[0.01 0.025 0.05 0.1 0.2 0.4 0.85 0.9 1 1 1];
costfxnC = @(myC) goodnessOfCollapseWithC(dataTable,myC,voltnum,0);

opts = optimoptions('fmincon','Display','off');
lb = zeros(size(C_init));
ub = Inf*ones(size(C_init));
% for V > 0 (voltnum > 1)
lb(1:5) = zeros(1,5);
ub(1:5) = zeros(1,5);
% for V >= 60V (voltnum = 6,7)
lb(10) = 0;
ub(10) = 0;

newC = fmincon(costfxnC,C_init,[],[],[],[],lb,ub,[],opts);

disp(newC)
