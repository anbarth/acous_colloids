dataTable = may_ceramic_09_17;
phi_list = unique(dataTable(:,1));
stress_list = unique(dataTable(:,2));
load("y_09_19_ratio_with_and_without_Cv.mat")
y_optimal = y_Cv;
[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13);
x_crossover = ( (A/eta0)^(1/(-2-delta)) + 1 )^-1;

minPhi = 0.18;
maxPhi = 0.62;
cmap = viridis(256);
myColor = @(phi) cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);

phimu = 0.65;
f = @(sigma,jj) sigma ./ (sigmastar(jj)+sigma);

[x,F,deltaF] = calc_x_F(dataTable,y_optimal);
a = 10;
figure; hold on;
ax1 = gca;
ax1.XScale = 'log';
yline(phi0)
ylim([0.5 0.75])
title(a)
%for ii=6:9
for ii=1:length(phi_list)
    myPhi = phi_list(ii);
    myIndices = dataTable(:,1)==myPhi & dataTable(:,3)==0;
    myX = x(myIndices);
    mySigma = dataTable(myIndices,2);

    [mySigma,sortIdx] = sort(mySigma);
    myX = myX(sortIdx);

    phiJ = myPhi + a*(phi0-myPhi)^(-2/delta)*(1-myX);
    
    % wyart cates
    %phiJ = myPhi + a*(phi0-myPhi)*(1/(phi0-phimu)-f(mySigma,1)/(phi0-myPhi));

    plot(mySigma,phiJ,'-o','LineWidth',0.5,'Color',myColor(myPhi));
    plot(mySigma(myX > x_crossover),phiJ(myX > x_crossover),'-o','LineWidth',2,'Color',myColor(myPhi));
end

