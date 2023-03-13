global stress_list;
sigmastar = 26.4;
F0 = exp(-(sigmastar ./ stress_list).^(1));

costfxnF = @(x) goodnessOfCollapseWithCGF([C_iter(10,:),G_iter(10,:),x],0);
F1 = fmincon(costfxnF,F0,[],[],[],[],zeros(15,1),ones(15,1));
goodnessOfCollapseWithCGF([C_iter(10,:),G_iter(10,:),F1],1)