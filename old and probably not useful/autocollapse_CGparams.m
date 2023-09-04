function autocollapse_CGparams(fname)
% num iterations
N = 10;

% oldC_iter = C_iter;
% oldG_iter = G_iter;
% oldSigma_iter = sigma_iter;
% oldPhi_iter = phi_iter;
% oldMyGoodness = myGoodness;

% initial guess: handpicked params
oldC = ones(1,6)*0.5;
oldG = ones(1,8)*0.5;
%oldC = [2.4,2,1.7,1.5,1.15,1,0.85,0.6]/2.4;
%oldC = oldC(1:6);
%oldG = [1,1,1,1,0.98,0.95,0.92,0.9];
oldSigma = 26.4;
%oldSigma = sigmastar;
oldPhi = 0.58;
% oldC = oldC_iter(end,:);
% oldG = oldG_iter(end,:);
% oldSigma = oldSigma_iter(end);
% oldPhi = oldPhi_iter(end);


% matrix of Cs and Gs where row indexes interation
C_iter = zeros(N+1,6);
C_iter(1,:) = oldC;
G_iter = zeros(N+1,8);
G_iter(1,:) = oldG;
sigma_iter = zeros(N+1,1);
sigma_iter(1) = oldSigma;
phi_iter = zeros(N+1,1);
phi_iter(1) = oldPhi;

% also keep track of goodness
myGoodness = zeros(N+1,1);
myGoodness(1) = goodnessOfCollapseWithCGparams([oldC,oldG,oldSigma,oldPhi],0);

% iterate!!!
for ii=1:N
    disp(ii);
    % optimize C and G
    [newC, newG, newSigma, newPhi] = iter_collapseCGparams(oldC, oldG, oldSigma, oldPhi);
    % record new C and G + goodness
    C_iter(ii+1,:) = newC;
    G_iter(ii+1,:) = newG;
    sigma_iter(ii+1) = newSigma;
    phi_iter(ii+1) = newPhi;
    myGoodness(ii+1) = goodnessOfCollapseWithCGparams([newC,newG,newSigma,newPhi],0);
    % swap out old for new and go again!
    oldC = newC;
    oldG = newG;
    oldSigma = newSigma;
    oldPhi = newPhi;
end

% C_iter = [oldC_iter; C_iter(2:end,:)];
% G_iter = [oldG_iter; G_iter(2:end,:)];
% sigma_iter = [oldSigma_iter; sigma_iter(2:end)];
% phi_iter = [oldPhi_iter; phi_iter(2:end)];
% myGoodness = [oldMyGoodness; myGoodness(2:end)];
% N = length(myGoodness)-1;

% % plot the progression of C
% cmap = viridis(N+1);
% figure;hold on;
% for ii=1:N+1
%     plot(phi_list(1:6),C_iter(ii,:),'-o','Color',cmap(ii,:));
% end
% xlabel('\phi'); ylabel('C');
% 
% % plot the progression of G
% figure;hold on;
% for ii=1:N+1
%     plot(volt_list,G_iter(ii,:),'-o','Color',cmap(ii,:));
% end
% xlabel('V'); ylabel('G');
% 
% % plot the progression of sigma*
% figure;hold on;
% plot(1:N+1,sigma_iter,'-o');
% xlabel('N'); ylabel('\sigma*');
% 
% % plot the progression of phi0
% figure;hold on;
% plot(1:N+1,phi_iter,'-o');
% xlabel('N'); ylabel('\phi_0');
% 
% 
% % plot the progression of goodness
% figure;
% plot(1:N+1,myGoodness,'-o');
% xlabel('N'); ylabel('goodness');

%save("CGsig_iterations_phi0=64.mat",'C_iter','G_iter','sigma_iter','phi_iter','myGoodness');
save(fname,'C_iter','G_iter','sigma_iter','phi_iter','myGoodness');
end
