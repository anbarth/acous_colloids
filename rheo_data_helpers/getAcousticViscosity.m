function [eta,delta_eta] = getAcousticViscosity(rheoData,myT,showPlots)

if myT == 0
    % t=0 means no dethickening noticable
    % average over the viscosity before first application of acoustics
    tAcous = min(rheoData.acous(:,4));
    if tAcous == 0
        % no acoustics in this experiment? average over 60s
        tAcous = 60;
    end
    
    [eta,delta_eta] = getBaselineViscosity(rheoData,5,tAcous,showPlots);

else
    [eta,delta_eta] = getDethickenedViscosity(rheoData,myT,myT+10,showPlots);
end

end