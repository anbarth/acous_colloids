meera_cs_table = zeros(0,5);

for ii=1:size(meera_cornstarch_eta,1)
    for jj=1:size(meera_cornstarch_eta,2)

        myEta = meera_cornstarch_eta(ii,jj);
        if isnan(myEta)
            continue
        end

        mySigma = meera_cornstarch_sigma(ii,jj);
        myPhi = meera_cornstarch_phi(jj);

        meera_cs_table(end+1,:) = [myPhi mySigma 0 myEta 0];

    end
end