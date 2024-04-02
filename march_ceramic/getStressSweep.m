function [sigma,eta] = getStressSweep(mySweep,showPlot,myColor)

if nargin<2
    showPlot = 0;
end

myRows = getStressSweepDataTableRows(mySweep,0,[]);
sigma = myRows(:,2);
eta = myRows(:,4);

if showPlot && nargin < 3
    plot(sigma,eta,'-o','LineWidth',1)
elseif showPlot
    plot(sigma,eta,'-o','LineWidth',1,'Color',myColor)
end

end