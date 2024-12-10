function [eta,delta_eta,baselineEta,sloppy] = getAcousticViscosity(rheoData,myT,showPlots)

if myT == 0
    % t=0 means no dethickening noticable
    tAcous = min(rheoData.acous(rheoData.acous(:,4)>0,4));
    if isempty(tAcous)
        % no acoustics in this experiment? average over the last 30s
        t = getTime(rheoData);
        tEnd = max(t);
        [eta,delta_eta] = getBaselineViscosity(rheoData,tEnd-30,tEnd,showPlots);
    else
        % if there's acoustics in this experiment,
        % average over the viscosity 20s before first application of acoustics
        tStart = max(10,tAcous-20);
        [eta,delta_eta] = getBaselineViscosity(rheoData,tStart,tAcous,showPlots);
    end

    sloppy = false;
    baselineEta = eta;

else
    [eta,delta_eta] = getDethickenedViscosity(rheoData,myT,myT+10,showPlots); baselineEta=0; sloppy=false;
    %[eta,delta_eta,baselineEta,sloppy] = getDethickenedViscosity_excludeSloppy(rheoData,myT,myT+10,showPlots);
end

end