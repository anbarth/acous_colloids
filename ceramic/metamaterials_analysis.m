% metamaterialRows_44 = getMetamaterialRows(metamaterial_phi44_02_27,false);
% metamaterialRows_59 = getMetamaterialRows(metamaterial_phi59_02_27,false);
% metamaterialTable = [metamaterialRows_44;metamaterialRows_59];

colors = ['r','k','b'];
markers = ['o','d'];
sigmaRange = 3;
phiRange = 1:2;

phi = [0.44, 0.59];
sigma1 = [5.5, 20, 100];
sigma2 = [4.7,8,12];
sigma_all = [sigma1;sigma2];

figure; hold on;
ax1 = gca;
ax1.XScale = 'log';
ax1.YScale = 'log';
xlabel('AM frequency (Hz)')
ylabel('envelope height (rescaled)')

for jj=phiRange
    myPhi = phi(jj);
    marker = markers(jj);
    sigma = sigma_all(jj,:);
    for ii=sigmaRange
        mySigma = sigma(ii);
        myData = metamaterialTable(metamaterialTable(:,1)==myPhi & metamaterialTable(:,2)==mySigma,:);
        myFreqs = myData(:,4);
        myEnvHeights = myData(:,6);
        myRescaledHeights = myEnvHeights*(0.68-myPhi)^2;
    
        plot(myFreqs,myRescaledHeights,marker,'Color',colors(ii))
    end
end
%legend('44% 5.5pa','44% 20pa','44% 100pa','59% 4.7pa','59% 8pa','59% 12pa')

figure; hold on;
ax2 = gca;
ax2.XScale = 'log';
ax2.YScale = 'log';
xlabel('AM frequency (Hz)')
ylabel('avg viscosity (rescaled)')
for jj=phiRange
    myPhi = phi(jj);
    marker = markers(jj);
    sigma = sigma_all(jj,:);
    for ii=sigmaRange
        mySigma = sigma(ii);
        myData = metamaterialTable(metamaterialTable(:,1)==myPhi & metamaterialTable(:,2)==mySigma,:);
        myFreqs = myData(:,4);
        myAvgs = myData(:,5);
        myRescaledAvgs = myAvgs*(0.68-myPhi)^2;
    
        plot(myFreqs,myRescaledAvgs,marker,'Color',colors(ii))
    end
end
%legend('44% 5.5pa','44% 20pa','44% 100pa','59% 4.7pa','59% 8pa','59% 12pa')