function [eta,delta_eta,sloppy] = getAcousticViscosity(rheoData,myT,showPlots)

if myT == 0
    % t=0 means no dethickening noticable
    % average over the viscosity before first application of acoustics
    tAcous = min(rheoData.acous(rheoData.acous(:,4)>0,4));
    if isempty(tAcous)
        % no acoustics in this experiment? average over like, 60s
        tAcous = 80;
    end
    tStart = max(10,tAcous-20);

    [eta,delta_eta] = getBaselineViscosity(rheoData,tStart,tAcous,showPlots);

    sloppy = false;

else
    %[eta,delta_eta] = getDethickenedViscosity(rheoData,myT,myT+10,showPlots);
    [eta,delta_eta,sloppy] = getDethickenedViscosity_excludeSloppy(rheoData,myT,myT+10,showPlots);
end

end