meera_si_table = zeros(0,5);

for ii=1:size(meera_silica_eta,1)
    for jj=1:size(meera_silica_eta,2)

        myEta = meera_silica_eta(ii,jj);
        if isnan(myEta)
            continue
        end

        mySigma = meera_silica_sigma(ii,jj);
        myPhi = meera_silica_phi(jj);

        meera_si_table(end+1,:) = [myPhi mySigma 0 myEta 0];

    end
end