%phi0 = 0.6231;
%C = [1,1.2,1.1,0.7];
%A = @(P) 1 ./ (1 + 0.0122*P);

phi0=.5923;

%C = ones(1,4);
%C = [1,1.1,0.9,0.45]; % ver 1: line up elbows
%C = [1,1,1,0.6]; % after adding F_mod 2/16
%C = [1,1.1,0.6,0.2];
%C = 1.5*[1,1.1,0.9,0.45]; % ver 1: line up with meera
C = 1.4*[1.2,1.1,0.9,0.45];



% sigmastar = 5;
% a = 0.0068; b = 0.8561;
% c = 0.0016; d = 0.6668;
% C = 1.4*[1.25,1.1,0.9,0.45];

sigmastar = 10;
a = 0.0211; b = 0.7498;
c = 0.0029; d = 0.5806;

% sigmastar copied from sigmastar(V) picture
% sigmastar = 13.8;
% a = 0.0354; b = 0.7041;
% c = 0.0040; d = 0.5383;

% WC fit for sigma star
%  sigmastar = 17.3322; 
%  a = 0.0495; b = 0.6784;
%  c = 0.0052; d = 0.5121;



%A = @(P) (-0.571)*(log10(P)).^2 + (-0.1100)*log10(P) + (0.9423);
%F_mod_44 = [1     1     1     1     1     1     1     0.5     0.5     0.5     0.5     0.45     0.4     0.4     1     1];
f_mod_44 = [1     1     1     1     1     1     0.9     0.9    1     1     1    1.1     1.15     1.15     1     1];
f_mod_48 = [1     1     1     1     1     1     1     1     1     1.1     1.05     1     1     0.95     0.95     1];
f_mod_50 = [1     1     1     1     1     1.3     1.5     1.2     1.15     1.1     1     1     1     1     1     1];
f_mod_54 = [1     1     1     1     1     1     1     0.8     0.6    0.9     0.8     1     1     1.05     1.1     1.1];
%f_mod = [f_mod_44;f_mod_48;f_mod_50;f_mod_54];
f_mod = ones(4,16);


meeraMultiplier = 1/0.2*0.04;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if fudge
    phi_fudge_factors =    [0.2000    0.1698   -0.0302
        0.2500    0.2874    0.0374
        0.3000    0.2828   -0.0172
        0.3500    0.3782    0.0282
        0.4000    0.4114    0.0114
        0.4400    0.4182   -0.0218
        0.4800    0.4580   -0.0220
        0.5000    0.5018    0.0018
        0.5400    0.5523    0.0123];
    phi0 = 0.623;
    sigmastar = 10;
    a = 0.0793;
    b = 0.6502;
    c = 0.0029;
    d = 0.5806;
    meeraMultiplier = 1/0.2*0.04*97/44;
    C = 1.9*[1.2,1.1,0.9,0.45];
else
    phi_fudge_factors = [0.2000    0.2 0
        0.2500    0.25 0
        0.3000    0.3 0
        0.3500    0.35 0
        0.4000    0.4 0
        0.4400    0.44 0
        0.4800    0.48 0
        0.5000    0.5 0
        0.5400    0.54 0];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k=1;
f = @(sigma) exp(-(sigmastar ./ sigma).^k);
%A = @(P) 1 ./ (1 + a*P.^b);
A = @(P) exp(-c*P).^d;
%A = @(P) 1;