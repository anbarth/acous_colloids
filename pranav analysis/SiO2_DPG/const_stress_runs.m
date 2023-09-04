figure;
hold on;

colormap jet;
cmap = colormap;

phi = [20,25,30,35,40,44,46,48,50,52,53,54,55];
for ii = 1:length(phi)
    matFileName = strcat('phi_0',num2str(phi(ii)),'.mat');
    myPhi = phi(ii)/100;
    load(matFileName);
    myColor = cmap(round(1+255*(0.55-myPhi)/(0.55-0.2)),:);
    plot(sigma_1Pa(:,1),CSV*sigma_1Pa(:,4),'-o','Color',myColor);
end
legend('20%','25%','30%','35%','40%','44%','46%','48%','50%','52%','53%','54%','55%');
xlabel('t')
ylabel('\eta')
ax1 = gca;
ax1.XScale = 'log';
ax1.YScale = 'log';
