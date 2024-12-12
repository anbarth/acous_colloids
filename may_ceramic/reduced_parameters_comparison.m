%my_y_red_list = {y_reduced_handpicked,y_red_optimized,y_red_half_phi,y_red_half_phi_half_V,y_red_half_phi_half_V_half_sig};
my_y_red_list = {y_red_handpicked,y_red_optimal};

figure; hold on;
xlabel('V')
ylabel('sigma*')
V = linspace(0,80);
for ii=1:length(my_y_red_list)
    my_y_red = my_y_red_list{ii};
    [eta0, phi0, delta, A, width, sigmastarParams, alpha, b, q0params, q1params] = unzipReducedParams(my_y_red);
    plot(V,sigmastarParams(1)*V.^2+sigmastarParams(2)*V+sigmastarParams(3));
end
legend("handpicked","optimized handpicked","half phi","half phi, V","half phi, V, sigma")

figure; hold on;
ylabel('D(\phi,V=0)')
xlabel('\phi_0-\phi')
Dform = @(dphi,alpha,b,q0,q1) 1./((q0*dphi).^alpha+(q1*dphi).^(alpha+b));
for ii=1:length(my_y_red_list)
    my_y_red = my_y_red_list{ii};
    [eta0, phi0, delta, A, width, sigmastarParams, alpha, b, q0params, q1params] = unzipReducedParams(my_y_red);
    phi = linspace(0.2,phi0);
    q0 = q0params(1)*0 + q0params(2);
    q1params = q1params(1)*0 + q1params(2);
    D = Dform(phi0-phi,alpha,b,q0,q1params);
    plot(phi0-phi,D)
end
legend("handpicked","optimized handpicked","half phi","half phi, V","half phi, V, sigma")