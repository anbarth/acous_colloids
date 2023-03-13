tic;
% num iterations
N = 3;

% initial guess: handpicked params
oldC = [2.4,2,1.7,1.5,1.15,1,0.85,0.6]/2.4;
oldC = oldC(1:6);
oldG = [1,1,1,1,0.98,0.95,0.92,0.9];
global stress_list;
oldF = exp(-(26.4 ./ stress_list));

% matrix of Cs and Gs where row indexes interation
C_iter = zeros(N+1,6);
C_iter(1,:) = oldC;
G_iter = zeros(N+1,8);
G_iter(1,:) = oldG;
F_iter = zeros(N+1,15);
F_iter(1,:) = oldF;

% also keep track of goodness
myGoodness = zeros(N+1,1);
myGoodness(1) = goodnessOfCollapseWithCG([oldC,oldG,oldF],0);

% iterate!!!
for ii=1:N
    disp(ii);
    % optimize C and G
    [newC, newG, newF] = iter_collapse(oldC, oldG, oldF);
    % record new C and G + goodness
    C_iter(ii+1,:) = newC;
    G_iter(ii+1,:) = newG;
    F_iter(ii+1,:) = newF;
    myGoodness(ii+1) = goodnessOfCollapseWithCGF([newC,newG,newF],0);
    % swap out old for new and go again!
    oldC = newC;
    oldG = newG;
    oldF = newF;
end

% plot the progression of C
cmap = viridis(N+1);
figure;hold on;
for ii=1:N+1
    plot(phi_list(1:6),C_iter(ii,:),'-o','Color',cmap(ii,:));
end

% plot the progression of G
figure;hold on;
for ii=1:N+1
    plot(volt_list,G_iter(ii,:),'-o','Color',cmap(ii,:));
end

% plot the progression of F
figure;hold on;
ax1 = gca;
ax1.XScale = 'log';
for ii=1:N+1
    plot(stress_list,F_iter(ii,:),'-o','Color',cmap(ii,:));
end

% plot the progression of goodness
figure;
plot(1:N+1,myGoodness,'-o');

elapsedTime = toc;