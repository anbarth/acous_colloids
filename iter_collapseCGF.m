function [newC, newG, newF] = iter_collapseCGF(oldC, oldG, oldF)

% first optimize C
costfxnC = @(x) goodnessOfCollapseWithCGF([x,oldG,oldF],0);
newC = fmincon(costfxnC,oldC,[],[],[],[],zeros(6,1),ones(6,1));

% now optimize G
costfxnG = @(x) goodnessOfCollapseWithCGF([newC,x,oldF],0);
newG = fmincon(costfxnG,oldG,[],[],[],[],zeros(8,1),ones(8,1));

% now optimize F
costfxnF = @(x) goodnessOfCollapseWithCGF([newC,newG,x],0);
newF = fmincon(costfxnF,oldF,[],[],[],[],zeros(15,1),ones(15,1));

%goodnessOfCollapseWithCG([newC,newG],1);
end