function [sigma,eta] = getStressSweep(mySweep,showPlot,myColor)

if nargin<2
    showPlot = 0;
end

myRows = getStressSweepDataTableRows(mySweep,0,[]);
sigma = myRows(:,2);
eta = myRows(:,4);

if showPlot
    %figure; hold on;
    ax1 = gca;
    ax1.XScale = 'log';
    ax1.YScale = 'log';
    if nargin < 3
        plot(sigma,eta,'-o','LineWidth',1)
    else 
        plot(sigma,eta,'-o','LineWidth',1,'Color',myColor)
    end
end

end