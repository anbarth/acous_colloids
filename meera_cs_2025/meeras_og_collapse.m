dataTable = meera_cs_table;



% from the sheet Cphi2
C1 = 1/14.5*[0.015927632	0.018405264	0.097091989	0.449867948	0.738476722	0.690197403 ...
    1.09725352	1.434802329	1.901770102	2.192992289	2.439498924	2.409932549	...
    2.348813303	2.394189546	2.31713165	2.191783254	2.170025002	2.096806397	2.052581479...
    1.930983088	1.912993783	1.804182513	1.622650521	1.577736347	1.514463988	1.39644087	...
    1.242312633	1.260424989	1.093716733	0.953947368];
phi_list = unique(dataTable(:,1));
D = C1./(0.65-phi_list');

% extracted from spreadsheet
sigmastar = 3.885413;
phi0 = 0.6448091;


y = [eta0 0.65 delta A width sigmastar D];

% why is it so bad? i messed smth up i assume
show_F_vs_x(dataTable,y,@modelHandpicked)
show_F_vs_xc_x(dataTable,y,@modelHandpicked)