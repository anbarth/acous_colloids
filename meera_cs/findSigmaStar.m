
for ii=1:size(meera_cornstarch_f,1)
    for jj=1:size(meera_cornstarch_f,2)

        myF = meera_cornstarch_f(ii,jj);
        if myF == 0
            continue
        end

        mySigma = meera_cornstarch_sigma(ii,jj);
        
        sigmastar = -1*mySigma*log(myF);

        if abs(sigmastar-3.8845) > 0.001
            disp(sigmastar)
        end

    end
end