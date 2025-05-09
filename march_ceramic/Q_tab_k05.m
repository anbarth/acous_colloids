function Q_table = Q_tab_k05()



    rows44 = [0.1, 0.01;
        0.2, 0.1;
        0.3, 0.5;
        0.5, 3;
        1, 4;
        2, 5;
        5, 20];
        %10, 100;
        %20, 600];
    rows44(:,2) = rows44(:,2)*1.5;
    rows44 = [0.44*ones(size(rows44,1),1),rows44];

    rows48 = [0.05, 0.5;
        0.1, 10;
        0.2, 30;
        0.3, 5;
        0.5, 30;
        1, 100;
        2, 200;
        5, 600;
        10, 2000];
        %20, 600];
    rows48(:,2) = rows48(:,2)*0.02;
    rows48 = [0.48*ones(size(rows48,1),1),rows48];

    rows52 = [0.1, 0.1;
        0.2, 0.3;
        0.3, 0.3;
        0.5, 0.6;
        1, 1;
        2, 3;
        5, 5;
        10, 10;
        20, 30];
        %50, 150];
    rows52(:,2) = rows52(:,2)*1.2;
    rows52 = [0.52*ones(size(rows52,1),1),rows52];

    rows56 = [0.05, 0.03;
        0.1, 0.2;
        0.2, 0.1;
        0.3, 0.2;
        0.5, 0.3;
        1, 0.5;
        2, 1;
        5, 2;
        10, 3;
        20, 7;
        50, 50];
        %100, 450];
        rows56 = [0.56*ones(size(rows56,1),1),rows56];

        rows59 = [0.05, .3;
        0.1, 0.1;
        0.2, 0.1;
        0.3, 0.1;
        0.5, 0.1;
        1, 0.2;
        2, 0.3;
        3, 0.5;
        5.5, 0.5;
        10, 1;
        20, 1;
        50, 5;
        100, 10];
        %200, 50];
        rows59 = [0.59*ones(size(rows59,1),1),rows59];
        
 Q_table = [rows44;rows48;rows52;rows56;rows59];

end