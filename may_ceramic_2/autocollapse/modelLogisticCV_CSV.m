function [x,F,delta_F,F_hat,eta,delta_eta,eta_hat] = modelLogisticCV_CSV(stressTable, y)

CSV=25;

[x,F,delta_F,F_hat,eta,delta_eta,eta_hat] = modelLogisticCV(stressTable, y);

F=F*CSV;
delta_F=delta_F*CSV;
F_hat=F_hat*CSV;
eta=eta*CSV;
delta_eta=delta_eta*CSV;
eta_hat=eta_hat*CSV;


end