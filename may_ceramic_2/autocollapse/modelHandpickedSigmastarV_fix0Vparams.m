function [x,F,delta_F,F_hat,eta,delta_eta,eta_hat] = modelHandpickedSigmastarV_fix0Vparams(stressTable, y0V, sigmastarV)

% y0V comes from modelHandpickedAllExp0V
eta0 = y0V(1);
phi0 = y0V(2);
delta = y0V(3);
A = y0V(4);
width = y0V(5);
sigmastar0V = y0V(6);
D0V = y0V(7:end);

y(1) = eta0;
y(2) = phi0;
y(3) = delta;
y(4) = A;
y(5) = width;
y(6) = sigmastar0V;
y(7:12) = sigmastarV;
y(13:end) = D0V;

[x,F,delta_F,F_hat,eta,delta_eta,eta_hat] = modelHandpickedSigmastarV(stressTable, y);



end