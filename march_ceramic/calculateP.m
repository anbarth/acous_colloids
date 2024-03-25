function P = calculateP(phi,sigma,V,dataTable)

eta_0V = dataTable(dataTable(:,1)==phi & dataTable(:,2)==sigma & dataTable(:,3)==0,4);
gamma_dot_0V = sigma/eta_0V;

P = V^2/sigma/gamma_dot_0V;
%P = V^2/sigma/gamma_dot_0V*exp(-1/(0.68-phi));
%P = V^2/sigma/gamma_dot_0V*exp(-(1/(0.68-phi))^0.75);
%P = V^2;
%P = V^2/sigma^2;
%P = V^2/sigma^2/gamma_dot_0V/phi^2;
%P = V^2/sigma^0.5;
%P=V^2/gamma_dot_0V^0.5;

% if phi == 0.44
%     P = P*5;
% elseif phi == 0.59
%     P = P*0.1;
% end

return
if phi == 0.44
    Q = [0.001, 1;
        0.003, 1;
        0.01, 1;
        0.03, 1;
        0.05, 1;
        0.1, 0.3;
        0.2, 1.5;
        0.3, 5;
        0.5, 10;
        1, 30;
        2, 10;
        5, 30;
        10, 100;
        20, 600];
    
    qIndex = find(Q(:,1)==sigma);
    if qIndex
        P = P*Q(qIndex,2);
    else
        disp(strcat("sigma value ",num2str(sigma)," not found in Q"))
    end
end

if phi == 0.52
    Q = [0.001, 1;
        0.003, 1;
        0.01, 1;
        0.03, 1;
        0.05, 1;
        0.1, 0.6;
        0.2, 1.5;
        0.3, 0.75;
        0.5, 1.5;
        1, 3;
        2, 3;
        5, 3;
        10, 15;
        20, 30;
        50, 150];
    
    qIndex = find(Q(:,1)==sigma);
    if qIndex
        P = P*Q(qIndex,2);
    else
        disp(strcat("sigma value ",num2str(sigma)," not found in Q"))
    end
end

end