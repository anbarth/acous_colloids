phi = [0.3,0.4,0.44,0.48,0.59];
eta = [0.6,1.1,2,2.5,9.5];

figure; hold on;
plot(phi,eta.^(-1/2),'o')

p = polyfit(phi,eta.^(-1/2),1);
disp(-p(2)/p(1))
plot([.15,.65],p(1)*[.15,.65]+p(2));
xlabel('\phi')
ylabel('\eta^{-1/2} (Pa s)^{-1/2}');