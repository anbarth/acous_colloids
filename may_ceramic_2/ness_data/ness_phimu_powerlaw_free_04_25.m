dataTable = chris_table_04_25;

figure; hold on; makeAxesLogLog;
xlabel('\phi_\mu-\phi')
ylabel('\eta')
prettyplot

phi = [];
eta = [];

for kk=1:size(dataTable,1)
    stress = dataTable(kk,2);
    if stress > 10
        myPhi = dataTable(kk,1);
        myEta = dataTable(kk,4);

        phi(end+1) = myPhi;
        eta(end+1) = myEta;
    end
end


powerlaw = @(a,b,c,x) a*(c-x).^b;
powerlawfittype = fittype(powerlaw,'Independent','x');
mypowfit = fit(phi',eta',powerlawfittype,'StartPoint',[1 -2 0.6],'Lower',[0 -Inf 0],'Upper',[Inf 0 1],'Weights',(eta').^(-2));
phimu = mypowfit.c;
disp(phimu)

%phi0 = 0.645;
plot(phimu-phi,eta,'ko');
phiF = linspace(min(phi),max(phi));
plot(phimu-phiF,powerlaw(mypowfit.a,mypowfit.b,mypowfit.c,phiF),'r-')
%plot(phi0-phiF,powerlaw(1,-2,0.645,phiF),'r-')