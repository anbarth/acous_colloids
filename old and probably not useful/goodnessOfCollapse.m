function [goodness,xc] = goodnessOfCollapse(x,F,print)

if nargin < 3
    print = 0;
end

% sort from lowest to highest x
sorting_matrix = sortrows([x,F]);
x = sorting_matrix(:,1);
F = sorting_matrix(:,2);


% try fitting F vs x to F = a (c-x)^b
fitfxn = @(s) s(1)*(s(3)-x).^s(2);
costfxn = @(s) sum(( (fitfxn(s)-F)./F ).^2);


opts = optimoptions('fmincon','Display','off');
best_params = fmincon(costfxn, [0.5,-2,25],[],[],...
            [],[],[],[],[],opts);
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
if print == 1
    disp(best_params(1));
    disp(best_params(2));
    disp(best_params(3));

    figure;hold on;
    ax1 = gca;
    ax1.XScale = 'log';
    ax1.YScale = 'log';

    plot(x, F, 'o');
    plot(x,fitfxn(best_params));

    figure;hold on;
    ax1 = gca;
    ax1.XScale = 'log';
    ax1.YScale = 'log';

    plot(best_params(3)-x, F, 'o');
    plot(best_params(3)-x,fitfxn(best_params));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%x_fake = logspace(log10(min(x)),log10(max(x)));
%plot(x_fake,exp(polyval(p,log(x_fake))));
goodness = costfxn(best_params);
xc = best_params(3);

end

