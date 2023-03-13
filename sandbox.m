a1 = 1;
a2 = 1;
b1 = -2;
b2 = -2;
c1 = 500;
c2 = 2000;
k = 1.5;

x = logspace(2,3.5,1000);
F1 = a1*(c1-x(x<c1)).^b1;
%F3 = a1*(c1-k*x(x<c1/k)).^b1;
F2 = a2*(c2-x(x<c2)).^b2;


figure; hold on;
ax1 = gca;
ax1.XScale = 'log';
ax1.YScale = 'log';
plot(x(x<c1),F1);
%plot(1/c1*x(x<c1),F1*c2^b2/c1^b1);
plot(x(x<c2),F2);
%plot(x(x<c1/k),F3);
%plot(x(x<c1/k),F3*k^b1);
%ylim([0 0.005]);