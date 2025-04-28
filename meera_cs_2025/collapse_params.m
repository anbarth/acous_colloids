%phi0=.5923;
phi0 = 0.65;

numPhi = length(unique(meera_cs_table(:,1)));
phi_list = unique(meera_cs_table(:,1));

%C = ones(numPhi,7);

C1 = [0.015927632	0.018405264	0.097091989	0.449867948	0.738476722	0.690197403 ...
    1.09725352	1.434802329	1.901770102	2.192992289	2.439498924	2.409932549	...
    2.348813303	2.394189546	2.31713165	2.191783254	2.170025002	2.096806397	2.052581479...
    1.930983088	1.912993783	1.804182513	1.622650521	1.577736347	1.514463988	1.39644087	...
    1.242312633	1.260424989	1.093716733	0.953947368];
C1 = C1 ./ (phi0-phi_list');
C = [C1',C1',C1',C1',C1',C1',C1'];
C = C / 13.9;


sigmastar = 3.8845*ones(1,7);
f = @(sigma,jj) exp(-(sigmastar(jj) ./ sigma).^1);



phi_fudge = zeros(numPhi,1)';

% calculated using calcCollapse with the above parameters held fixed
eta0 = 0.2515;
A = 0.1613;
delta = -1.44;
width = 0.788;