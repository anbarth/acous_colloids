dataTable = may_ceramic_09_17;
load("y_09_19_ratio_with_and_without_Cv.mat")
y_optimal = y_Cv;
load("myUncertainties.mat")

%paramNums = 6:12; %sigmastar
paramNums = 13:25; %C(0V)

cutoffSD=2.5;






for kk=1:length(paramNums)
    figure;
    hold on;
    paramNum = paramNums(kk);
    param_init = y_optimal(paramNum);

    myEps = epsilon(paramNum,:);
    mySSR = ssr(paramNum,:);
    plot(myEps,mySSR,'o','LineWidth',1)
    
    ft1 = fittype('a*x^2');
    opts = fitoptions(ft1);
    opts.StartPoint = 1e6;
    myFit1 = fit(myEps',mySSR',ft1,opts);
    p1 = myFit1.a;
    plot(myEps,p1*myEps.^2);
    myCI = sqrt(cutoffSD/p1);
    
    
    %%p = polyfit(myEps,mySSR,2);
    %%myCI = sqrt(cutoffSD/p(1));
    %%plot(myEps,p(1)*myEps.^2+p(2)*myEps+p(3),'-r','LineWidth',1);
    
    disp([param_init myCI])
    yline(cutoffSD)
    xline(myCI)
    xline(-myCI)
    title(paramNum)
end