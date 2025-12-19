function f = getRingingFrequency(rheoData,tStart,tEnd,showPlot)

% get eta, t data in the specified window
eta = getViscosity(rheoData,1,0);
t = getTime(rheoData);

startIndex = find(t>=tStart,1,'first');
endIndex = find(t<=tEnd,1,'last');

myEta = eta(startIndex:endIndex);
myT = t(startIndex:endIndex);

% find the window where the viscosity changes (ie where acoustics is on)
acousticWindowIndexes = findchangepts(myEta,MaxNumChanges=2);


if length(acousticWindowIndexes) == 2
    acousStartIndex = acousticWindowIndexes(1)+2;
    acousEndIndex = acousticWindowIndexes(2)-2;
    referenceEndIndex = acousStartIndex-5 + startIndex-1;
    referenceStartIndex = acousStartIndex-55 + startIndex-1;

    acousEta = myEta(acousStartIndex:acousEndIndex);
    acousT = myT(acousStartIndex:acousEndIndex);

    fourier_amps = fft(acousEta-mean(acousEta));
    N = length(fourier_amps);
    sample_rate = acousT(2)-acousT(1);
    fourier_freqs = sample_rate/N*(0:N-1);

    [maxpeak, maxpeakindex] = max(abs(fourier_amps));

    f = fourier_freqs(maxpeakindex);
    
    
else
    % failed to find 2 change points
    f=0;
end


if showPlot
    % plot eta vs t
    etaVsT(rheoData,1,0);
    hold on;

    % zoom in on acoustic perturbation
    xlim([tStart-3 tEnd]);
    etaRange = max(myEta)-min(myEta);
    ylim([min(myEta)-etaRange/4 max(myEta)+etaRange/4]);
    
    if length(acousticWindowIndexes) == 2
        % show change points
        scatter(myT([acousStartIndex,acousEndIndex]),myEta([acousStartIndex,acousEndIndex]),30,'r');
        scatter(t([referenceStartIndex,referenceEndIndex]),eta([referenceStartIndex,referenceEndIndex]),30,'b');
        
        % show highest fourier mode
        print(f)
    

    end
end

%dethickenedEta = getDethickenedViscosity(getViscosity(rheoData),getTime(rheoData),tStart,tEnd);

end