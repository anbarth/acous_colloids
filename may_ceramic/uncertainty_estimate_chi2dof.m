dataTable = may_ceramic_09_17;
load("y_09_19_ratio_with_and_without_Cv.mat")
y_optimal = y_Cv;
load("myUncertainties.mat")

P = 116 - 13 - 5*6 - 2;
N = size(dataTable,1);
dof = N-P;


chi2 = @(y) sum(getResiduals(dataTable,y).^2);

chi2_optimal = chi2(y_optimal);

% this number answers, "given a bunch of trials, how often would i expect
% to see a chi2 value higher than this one?"
disp(1-chi2cdf(chi2_optimal,dof))
% the answer seems to be: every time! does that indicate we're overfitting?

% this is how high chi2 needs to get for me to feel worried
% if you're getting this chi2, then the answer to "how often would i expect
% to see a chi2 value higher than this one?" is only 5% of the time
chi2_cutoff = chi2inv(0.95,dof);

%paramNums = 6:12; %sigmastar
%paramNums = 13:25; %C(0V)
paramNums = 4;

for kk=1:length(paramNums)
    figure;
    hold on;
    paramNum = paramNums(kk);
    param_init = y_optimal(paramNum);

    myEps = epsilon(paramNum,:);
    mySSR = ssr(paramNum,:);
    plot(myEps,mySSR+chi2_optimal,'o','LineWidth',1)
    
    ft1 = fittype('a*x^2');
    opts = fitoptions(ft1);
    opts.StartPoint = 1e6;
    myFit1 = fit(myEps',mySSR',ft1,opts);
    p1 = myFit1.a;
    
    myCI = sqrt((chi2_cutoff-chi2_optimal)/p1);

    eps_fake = linspace(-myCI,myCI);
    plot(eps_fake,p1*eps_fake.^2+chi2_optimal);
    
    
    %%p = polyfit(myEps,mySSR,2);
    %%myCI = sqrt(cutoffSD/p(1));
    %%plot(myEps,p(1)*myEps.^2+p(2)*myEps+p(3),'-r','LineWidth',1);
    
    disp([param_init myCI])
    title(paramNum)
end