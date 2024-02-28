% metamaterialRows_44 = getMetamaterialRows(metamaterial_phi44_02_27,false);
% metamaterialRows_59 = getMetamaterialRows(metamaterial_phi59_02_27,false);
% metamaterialTable = [metamaterialRows_44;metamaterialRows_59];

colors = ['r','k','b','g'];

sigmaRange = 1:4;

phi = 0.59;
sigma = [4.7,8,12,200];

figure; hold on;
ax1 = gca;
ax1.XScale = 'log';
ax1.YScale = 'log';
xlabel('AM frequency (Hz)')
ylabel('envelope height (rescaled)')


myPhi = phi;
for ii=sigmaRange
    mySigma = sigma(ii);
    myData = metamaterialTable(metamaterialTable(:,1)==myPhi & metamaterialTable(:,2)==mySigma,:);
    myFreqs = myData(:,4);
    myEnvHeights = myData(:,6);
    myRescaledHeights = myEnvHeights*(0.68-myPhi)^2;

    plot(myFreqs,myRescaledHeights,'d','Color',colors(ii))
end

legend('59% 4.7pa','59% 8pa','59% 12pa','59% 200pa')

figure; hold on;
ax2 = gca;
ax2.XScale = 'log';
ax2.YScale = 'log';
xlabel('AM frequency (Hz)')
ylabel('avg viscosity (rescaled)')

myPhi = phi;
for ii=sigmaRange
    mySigma = sigma(ii);
    myData = metamaterialTable(metamaterialTable(:,1)==myPhi & metamaterialTable(:,2)==mySigma,:);
    myFreqs = myData(:,4);
    myAvgs = myData(:,5);
    myRescaledAvgs = myAvgs*(0.68-myPhi)^2;

    plot(myFreqs,myRescaledAvgs,'d','Color',colors(ii))
end
legend('59% 4.7pa','59% 8pa','59% 12pa','59% 200pa')