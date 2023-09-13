function eta = getAcousticViscosity(rheoData,myT,showPlots)

if myT == 0
    % t=0 means no dethickening noticable
    tAcous = min(rheoData.acous(:,4));
    if tAcous == 0
        tAcous = 60;
    end
    
    eta = getBaselineViscosity(rheoData,0,tAcous,showPlots);

else
    eta = getDethickenedViscosity(rheoData,myT,myT+10,showPlots);
end

end