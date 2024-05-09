function goodness = goodnessOfCollapse(x,F,print,xc)

if nargin < 3
    print = 0;
end
if nargin < 4
    xc = 1;
end

% sort from lowest to highest x
% (makes plotting nicer)
sorting_matrix = sortrows([x,F]);
x = sorting_matrix(:,1);
F = sorting_matrix(:,2);


% try fitting F vs x to F = a (xc-x)^b
%xc=10;
fitfxn = @(s) s(1)*(xc-x).^s(2);
costfxn = @(s) sum(( (fitfxn(s)-F)./F ).^2);



if any(x > xc)
    disp("WARNING x>xc found")
    goodness=Inf;
    return
    %F = F(x<xc);
    %x = x(x<xc);
end

opts = optimoptions('fmincon','Display','off');
best_params = fmincon(costfxn, [0.5,-2.5],[],[],...
            [],[],[],[],[],opts);
goodness = costfxn(best_params);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
if print == 1
    disp(best_params);

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

    plot(xc-x, F, 'o');
    plot(xc-x,fitfxn(best_params));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

