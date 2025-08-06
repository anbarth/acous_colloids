function sigma = sigma_predicted(rate,phi,v,dataTable,y,myModelHandle)


solveMe =  @(logsigma) exp(logsigma)/viscosity_prediction(phi,exp(logsigma),v,dataTable,y,myModelHandle)-rate;
opts = optimset('Display','off');
[logsigma,~,exitflag,~] = fzero(solveMe,1.5,opts);
if exitflag <=0
    sigma = NaN;
else
    sigma = exp(logsigma);
end
end