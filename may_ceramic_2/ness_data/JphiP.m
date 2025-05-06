function myJ = JphiP(phi_J1,B1,beta1,phi_J2,B2,beta2,Pc,phi,P)

phiJ = @(phi_J,B,beta,J) phi_J./(1+B*J.^beta); 
f = @(P,Pc) exp(-Pc./P);
phiJP = @(phi_J1,B1,beta1,phi_J2,B2,beta2,Pc,J,P) phiJ(phi_J1,B1,beta1,J).*(1-f(P,Pc)) + phiJ(phi_J2,B2,beta2,J).*f(P,Pc);

myJ = zeros(size(phi));
for ii=1:length(phi)
    % set this to zero and solve for J
    myProblem = @(J) phiJP(phi_J1,B1,beta1,phi_J2,B2,beta2,Pc,J,P) - phi(ii);
    
    J1 = (1/B1*(phi_J1/phi(ii)-1))^(1/beta1);
    J2 = (1/B2*(phi_J2/phi(ii)-1))^(1/beta2);
    Javg = (J1+J2)/2;
    opts = optimset("MaxFunEvals",1e6,'MaxIter',4e6,"Display",'off');
    [myJii, ~, exitflag, ~] = fsolve(myProblem,Javg,opts);
    %[myJii, ~, exitflag, ~] = fzero(myProblem,Javg,opts);
    if exitflag==1
        myJ(ii) = myJii;
    else
        myJ(ii) = NaN;
        disp("WARNING fsolve did not converge in JphiP")
    end
end

end