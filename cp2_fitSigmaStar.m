figure;
hold on;
scatter(volt_list,sigmaStarP);

fitfxn = @(k) k(3) + k(4) ./ (1+exp(-1*k(1)*(volt_list-k(2))));
costfxn = @(k) sum(( (fitfxn(k)-sigmaStarP) ).^2); 
myK = fmincon(costfxn,[1/20,50,14,15],[-1,0,0,0;0,0,0,0;0,0,0,0;0,0,0,0],[0,0,0,0]);
V_fake = linspace(0,100); 
sig_fake = myK(3) + myK(4) ./ (1+exp(-1*myK(1)*(V_fake-myK(2))));
disp(myK)
plot(V_fake,sig_fake,'r')