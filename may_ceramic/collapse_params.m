%phi0=.5923;
phi0 = 0.69;

%sigmastar = 0.2784; %k=1
%sigmastar = 0.1647; %k=0.5
%sigmastar = 0.2149; %k=0.75

meeraMultiplier_X = 1/2*15.4/13.95;
% glycerol viscosity 20c: 1.412 Pa s
% 90-10 GW viscosity 20c: 0.23 Pa s
% expect this factor to be 0.23/1.412 = 0.163
meeraMultiplier_Y = 1/0.2*0.09; %=0.45. hm, not what i expected
%meeraMultiplier = 1/0.2*0.04;



% C = ones(9,8);

% write C for each voltage separately
% found by hand
%C1 = 0.96*[0.01 0.025 0.05 0.1 0.2 0.4 0.85 0.9 1 1 1];
% found by calcC (except i set the first two values meself)
C1 = [ 0.01    0.025    0.1389    0.2379    0.3716    0.4516    0.7308    0.7433    0.8549    0.8376    0.8586];
C2 = [0.0142    0.0280    0.0514    0.0986    0.1938    0.3852    0.8167    0.8647    0.9607    0.9607    0.9607];
C3 = [0.0187    0.0320    0.0547    0.1011    0.1954    0.3862    0.8179    0.8653    0.9660    0.9658    0.9753];
C4 = C1;
C5 = C1;
C6 = C1;
C7 = C1;
C = [C1',C2',C3',C4',C5',C6',C7'];
%C = 1/10*[C1',C1',C1',C1',C1',C1',C1',C1'];





%sigmastar = 0.36*ones(1,7);
sigmastar = [0.3600    0.6566    0.6435    0.7994    0.9990    1.3038    1.6757];
f = @(sigma,jj) exp(-(sigmastar(jj) ./ sigma).^1);