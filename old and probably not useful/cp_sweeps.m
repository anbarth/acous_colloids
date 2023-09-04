% change this list to modify which phis are included in the fit!
phis = [46,48,50,52,54];
%phis = [44,46,48,50];

stressTable = cp_data;
% only include volume fractions listed at the top
include_me = false(size(stressTable,1),1);
for ii=1:size(stressTable,1)
    if any(phis/100==stressTable(ii,1))
        include_me(ii) = true;
    end
end
stressTable = stressTable(include_me,:);

sigma = stressTable(:,3)/CSS;
eta = stressTable(:,4)/CSV;
phi = stressTable(:,1);


figure;
hold on;
ax1 = gca;
ax1.XScale = 'log';
ax1.YScale = 'log';
colormap turbo;
cmap = colormap;
for ii=1:length(phis)
    myPhi = phis(ii)/100;
    myData = stressTable(stressTable(:,1)==myPhi,:);
    myStress=myData(:,3)/CSS;
    myEta=myData(:,4)/CSV;
    myColor = cmap(round(1+255*(0.55-myPhi)/(0.55-0.44)),:);
    plot(myStress,myEta,'o--','Color',myColor);
end
%title('stress sweeps');
xlabel('\sigma (Pa)');
ylabel('\eta (Pa s)');