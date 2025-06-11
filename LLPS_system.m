v1 = @(c1,c2,v) (c2*v-1)/(c2-c1);
v2 = @(c1,c2,v) (1-c1*v)/(c2-c1);
n1 = @(c1,c2,v) c1*v1(c1,c2,v);
n2 = @(c1,c2,v) c2*v2(c1,c2,v);
rho = @(rho1,rho2,c1,c2,v) (rho1*v1(c1,c2,v)+rho2*v2(c1,c2,v))./v;

c1 = 0.2;
c2 = 0.7;
rho1 = 1;
rho2 = 2;
v = linspace(1/c2,1/c1);

figure; hold on;
xlabel('v')
ylabel('v1,v2')
plot(v,v1(c1,c2,v),'r-')
plot(v,v2(c1,c2,v),'b-')
yline(0)

figure; hold on;
xlabel('v'); ylabel('\rho')
yline(rho1)
yline(rho2)
plot(v,rho(rho1,rho2,c1,c2,v),'g-')