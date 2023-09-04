%function C = chooseC(phi0,sigmastar)
phi0=0.58;
sigmastar=21.64;
f = @(sig)exp(-(sigmastar ./ sig).^(1));


global volt_list stress_list phi_list data_by_vol_frac

% x_all = zeros(0,1);
% F_all = zeros(0,1);

figure; hold on;
cmap = viridis(256);
colormap(cmap);

ax1 = gca;
ax1.XScale = 'log';
ax1.YScale = 'log';

% vol frac, voltage, fit param
fit_params = zeros(6,8,4);

counter = 0;
for ii = 1:6
    for jj = 1:length(volt_list)
        counter = counter+1;
        phi = phi_list(ii)/100;
        voltage = volt_list(jj);
        phi_data = data_by_vol_frac{ii};
        sigma = stress_list(1:size(phi_data,2));
      
        eta = phi_data(jj,:); % viscosities for just this voltage
        x = f(sigma) ./ (-1*phi + phi0);
        F = eta*(phi0-phi)^2;
        
        % trim out nan values
        trim_me = ~isnan(F);
        x = x(trim_me);
        F = F(trim_me);
        sigma = sigma(trim_me);
        
        % try fitting F vs x to F = a (c-x)^b
        fitfxn = @(s) s(1)*(s(3)-f(sigma+s(4)) ./ (-1*phi + phi0)).^s(2); %%% TODO include +d... next to SIGMA. could +d be accounting for sigma uncertainty? look at d and d/sigma_min
        costfxn = @(s) sum(( (fitfxn(s)-F)./F ).^2);
        %costfxn = @(s) 1/length(F)*sum(abs( (fitfxn(s)-F)./F ));
        opts = optimoptions('fmincon','Display','off');
        best_params = fmincon(costfxn, [0.5,-2,21.5,0],[],[],...
            [],[],[],[],[],opts);
        fit_params(ii,jj,:) = best_params;
        myCG = 1/best_params(3);
        %disp([best_params min(F) max(F)]);
        % compare d to the uncertainty in F = a(c-x)^b+d
        % uncertainty in stress ~ minimum stress. uncertainty in phi ~ 
        %ratio(counter) = best_params(4)/min(F);
        %myCG=1;
        
%         figure;
%         hold on;
%         scatter(x,F);
%         xfake = logspace(log10(min(x)),log10(max(x)),100);
%         Fhat = best_params(1)*(best_params(3)-xfake).^(best_params(2));
%         plot(xfake,Fhat);
%         title(strcat("\phi=",num2str(phi),", V=",num2str(volt_list(jj))));
%         hold off;
        
        myColor = voltage*ones(size(sigma));
        myMarker = vol_frac_markers(ii);
        scat = scatter(1-myCG*x,F,[],myColor,'filled',myMarker);
        scat.MarkerFaceAlpha = 1;
    end
end

% trim out nan values
%trim_me = ~isnan(F_all);
%x_all = x_all(trim_me);
%F_all = F_all(trim_me);


%C=0;
%end

