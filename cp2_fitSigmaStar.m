figure;
hold on;
scatter(volt_list,sigmaStarV);

%fitfxn = @(k) k(3) + k(4) ./ (1+exp(-1*k(1)*(volt_list-k(2))));
%costfxn = @(k) sum(( (fitfxn(k)-sigmaStarV) ).^2); 
%myK = fmincon(costfxn,[1/20,50,14,15],[-1,0,0,0;0,0,0,0;0,0,0,0;0,0,0,0],[0,0,0,0]);

% fitfxn = @(k) k(1) + k(2) * exp(-1*k(3)./volt_list);
% costfxn = @(k) sum(( (fitfxn(k)-sigmaStarV) ).^2); 
% myK = fmincon(costfxn,[14,15,60],[0,0,0;0,0,0;0,0,0],[0,0,0]);

% fitfxn = @(k) k(1) + k(2) * tanh(k(3)*(volt_list-k(4)));
% costfxn = @(k) sum(( (fitfxn(k)-sigmaStarV) ).^2); 
% myK = fmincon(costfxn,[19, 5, 0.03, 60],[0,0,0,0;0,0,0,0;0,0,0,0;0,0,0,0],[0,0,0,0]);

fitfxn = @(k) k(3)-k(2)*cos(k(1)*volt_list);
costfxn = @(k) sum(( (fitfxn(k)-sigmaStarV) ).^2); 
myK = fmincon(costfxn,[pi/100,7,20],[0,0,0;0,0,0;0,0,0],[0,0,0]);

V_fake = linspace(0,100); 
%sig_fake = myK(1) + myK(2) * exp(-1*myL(3)./V_fake);
%myK = [19, 5, 0.03, 60];
%sig_fake = myK(1) + myK(2) * tanh(myK(3)*(V_fake-myK(4)));
sig_fake = myK(3)-myK(2)*cos(myK(1)*V_fake);
disp(myK)
plot(V_fake,sig_fake,'r')