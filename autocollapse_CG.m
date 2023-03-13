tic;
% num iterations
N = 10;

% initial guess: handpicked params
oldC = [2.4,2,1.7,1.5,1.15,1,0.85,0.6]/2.4;
oldC = oldC(1:6);
oldG = [1,1,1,1,0.98,0.95,0.92,0.9];

% matrix of Cs and Gs where row indexes interation
C_iter = zeros(N+1,6);
C_iter(1,:) = oldC;
G_iter = zeros(N+1,8);
G_iter(1,:) = oldG;

% also keep track of goodness
myGoodness = zeros(N+1,1);
myGoodness(1) = goodnessOfCollapseWithCG([oldC,oldG],0);

% iterate!!!
for ii=1:N
    disp(ii);
    % optimize C and G
    [newC, newG] = iter_collapse(oldC, oldG);
    % record new C and G + goodness
    C_iter(ii+1,:) = newC;
    G_iter(ii+1,:) = newG;
    myGoodness(ii+1) = goodnessOfCollapseWithCG([newC,newG],0);
    % swap out old for new and go again!
    oldC = newC;
    oldG = newG;
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

% plot the progression of goodness
figure;
plot(1:N+1,myGoodness,'-o');

elapsedTime = toc;