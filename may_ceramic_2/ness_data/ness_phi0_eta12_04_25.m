dataTable = chris_table_04_25;

figure; hold on; 
xlabel('\phi')
ylabel('\eta^{-1/2}')

phi = [];
eta12 = [];

for kk=1:size(dataTable,1)
    stress = dataTable(kk,2);
    if stress < 1e-3
        myPhi = dataTable(kk,1);
        myEta = dataTable(kk,4);
        plot(myPhi,myEta^(-1/2),'ok')
        
        phi(end+1)=myPhi;
        eta12(end+1)=myEta^(-1/2);
    end
end
prettyplot

myline = @(m,b,x) m*(b-x);
mylinefittype = fittype(myline,'Independent','x');
mylinefit = fit(phi(phi>0.6)',eta12(phi>0.6)',mylinefittype,'StartPoint',[-2 0.65]);
phiF = linspace(0.6,0.65);
plot(phiF,myline(mylinefit.m,mylinefit.b,phiF),'r-');
disp(mylinefit.b)


% p = polyfit(phi(phi>0.6),eta12(phi>0.6),1);
% phiF = linspace(0.6,0.65);
% plot(phiF,polyval(p,phiF),'r-')
% disp(-p(2)/p(1))