function [newC, newG, newSigma, newPhi] = iter_collapseCGparams(oldC, oldG, oldSigma, oldPhi)

% first optimize C
costfxnC = @(x) goodnessOfCollapseWithCGparams([x,oldG,oldSigma,oldPhi],0);
newC = fmincon(costfxnC,oldC,[],[],[],[],zeros(6,1),ones(6,1));

% now optimize G
costfxnG = @(x) goodnessOfCollapseWithCGparams([newC,x,oldSigma,oldPhi],0);
newG = fmincon(costfxnG,oldG,[],[],[],[],zeros(8,1),ones(8,1));

% now optimize sigma*
newSigma = oldSigma;
%costfxnSig = @(x) goodnessOfCollapseWithCGparams([newC,newG,x,oldPhi],0);
%newSigma = fmincon(costfxnSig,oldSigma,[],[],[],[],0,100);

% finally optimize phi0
newPhi = oldPhi;
%costfxnPhi = @(x) goodnessOfCollapseWithCGparams([newC,newG,newSigma,x],0);
%newPhi = fmincon(costfxnPhi,oldPhi,[],[],[],[],0.55,0.65);

%goodnessOfCollapseWithCG([newC,newG],1);
end