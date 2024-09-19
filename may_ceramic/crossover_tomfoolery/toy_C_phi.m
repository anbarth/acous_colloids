load("y_09_17_not_smooth.mat");
[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13);
C = C(:,1);
phi_list = unique(may_ceramic_09_17(:,1));

[phi_list,sortIdx] = sort(phi_list);
C = C(sortIdx);
figure; hold on;
plot(phi_list,C,'-o')

% values of C < 1 will have no effect on the shape of the jamming line,
% of course!