function [meeraX,meeraY] = stealMeerasData()

meeraX = [];
meeraY = [];

meeraFig = openfig("ScalingCornstarchSilica.fig");
axObjs = meeraFig.Children;
myScatters = axObjs(2).Children;
for ii = 2:length(myScatters)
    thisScatter = myScatters(ii);
    newX = thisScatter.XData;
    newY = thisScatter.YData;
    meeraX(end+1:end+length(newX)) = newX;
    meeraY(end+1:end+length(newY)) = newY;
end
close(meeraFig);

% 
% figure;
% hold on;
% ax1 = gca;
% ax1.XScale = 'log';
% ax1.YScale = 'log';
% xlim(ax1,[10^(-5) 15]);
% scatter(ax1,meeraX,meeraY);

% meeraHX = [];
% meeraHY = [];
% 
% fig = openfig("CardyCornstarchSilica.fig");
% axObjs = fig.Children;
% myScatters = axObjs(2).Children;
% for ii = 3:length(myScatters)
%     thisScatter = myScatters(ii);
%     newX = thisScatter.XData;
%     newY = thisScatter.YData;
%     meeraHX(end+1:end+length(newX)) = newX;
%     meeraHY(end+1:end+length(newY)) = newY;
% end
% 
% keepMe = meeraHX>0 & meeraHY>0;
% meeraHX = meeraHX(keepMe);
% meeraHY = meeraHY(keepMe);
% %meeraHX = meeraHX(meeraHY>0);
% %meeraHY = meeraHY(meeraHY>0);
% 
% figure;
% hold on;
% ax1 = gca;
% ax1.XScale = 'log';
% ax1.YScale = 'log';
% xlim(ax1,[10^(-5) 10^3]);
% ylim(ax1,[10^(-7) 10^6]);
% scatter(ax1,meeraHX,meeraHY);

end