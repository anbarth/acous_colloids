% 1 = cornstarch
% 2 = silica
% 3 = polydisperse aluminosilicate

cornstarch_table = meera_cs_table;
cornstarch_table = cornstarch_table(cornstarch_table(:,1)<=0.54,:);
cornstarch_table = [cornstarch_table, 1*ones(size(cornstarch_table,1),1)];

silica_table = meera_si_table;
silica_table = silica_table(silica_table(:,1)<=0.53,:);
silica_table = [silica_table, 2*ones(size(silica_table,1),1)];

ceramic_table = may_ceramic_09_17;
ceramic_table = ceramic_table(ceramic_table(:,3)==0,:);
ceramic_table = [ceramic_table, 3*ones(size(ceramic_table,1),1)];

joint_data_table = [cornstarch_table; silica_table; ceramic_table];

% joint parameters
y_ceramic_nonuniversal = y_ceramic_handpicked_03_19;
y_cs_nonuniversal = y_cs;
y_si_nonuniversal = y_si;
y_ceramic_nonuniversal(3:5) = [];
y_cs_nonuniversal(3:5) = [];
y_si_nonuniversal(3:5) = [];
y_joint = [-1.5, 1, 0.5, y_cs_nonuniversal, y_si_nonuniversal, y_ceramic_nonuniversal];