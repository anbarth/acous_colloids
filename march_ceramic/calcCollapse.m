dataTable = march_data_table_05_02;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));

eta0_init = 0.0045;
phi0_init = 0.68;
delta_init = -1.5;
sigmastar_init = [0.2784    0.3515    0.4130    0.4637    0.6290    0.8909    1.0958    1.4797];
C1 = [0.2 0.4706    1.2145    1.5268    1.2664    1.0458    0.9993    0.7640    0.6991];
C2 = [0.0880    0.1180    1.2636    1.5033    1.2550    1.0218    0.9864    0.7607    0.6921];
C3 = [ 0.0880    0.1180    1.1316    1.4465    1.2055    0.9676    0.9589    0.7441    0.6722];
C4 = [0.0880    0.1180    1.1430    1.4468    1.1923    0.9374    0.9525    0.7393    0.6621];
C5 = [0.0880    0.1180    0.9594    1.4224    1.1449    0.8703    0.9244    0.7262    0.6378];
C6 = [0.0880    0.1180    1.0061    1.3806    1.0617    0.7783    0.8779    0.7028    0.6055];
C7 = [0.0880    0.1180    0.9594    1.3378    0.9989    0.6987    0.8552    0.6818    0.5892];
C8 = [0.0880    0.1180    0.9919    1.3715    0.9639    0.6469    0.8524    0.6885    0.5890];
C_init = 1/10*[C1',C2',C3',C4',C5',C6',C7',C8'];

y_init = zipParams(eta0_init,phi0_init,delta_init,sigmastar_init,C_init);



% y = [eta0, phi0, delta, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]
costfxn = @(y) goodnessOfCollapseAllParams( march_data_table_05_02,phi_list,volt_list,y);

opts = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e4);
y_optimal = fmincon(costfxn,y_init,[],[],[],[],[],[],[],opts);

[eta0, phi0, delta, sigmastar, C] = unzipParams(y_optimal,length(phi_list));
