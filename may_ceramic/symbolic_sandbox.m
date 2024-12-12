syms alpha beta gamma gamma_fun X
Y = alpha*X^2 + beta*X + gamma;
gamma_fun = alpha^2+X;
Y = subs(Y,gamma,gamma_fun);
diff(Y,alpha)


%syms eta0 phi0 delta A h a2 a1 a0 alpha beta b1 b0 c1 c0;
