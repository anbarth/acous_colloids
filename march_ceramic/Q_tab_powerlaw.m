function Q_table = Q_tab_powerlaw()
% Q table for k=1, interpolating onto the best fit power law
% my_const=0.1423;
% my_exp=-1.4530;


    rows44 = [0.1, 0.5;
        0.2, 0.3;
        0.3, 1;
        0.5, 5;
        1, 10;
        2, 10;
        5, 40];
    rows44(:,2) = rows44(:,2)*1.2;
    rows44 = [0.44*ones(size(rows44,1),1),rows44];

    rows48 = [0.1, 0.01;
        0.2, 0.3;
        0.3, 0.5;
        0.5, 2;
        1, 10;
        2, 30;
        5, 100;
        10, 300];
    rows48(:,2) = rows48(:,2)*0.1;
    rows48 = [0.48*ones(size(rows48,1),1),rows48];

    rows52 = [0.1, 0.2;
        0.2, 0.2;
        0.3, 0.3;
        0.5, 1;
        1, 2;
        2, 3;
        5, 6;
        10, 15;
        20, 30];
    rows52(:,2) = rows52(:,2)*1;
    rows52 = [0.52*ones(size(rows52,1),1),rows52];

    rows56 = [0.1, 1;
        0.2, 0.3;
        0.3, 0.7;
        0.5, 0.8;
        1, 1.5;
        2, 3;
        5, 4;
        10, 5;
        20, 10;
        50, 50];
    rows56(:,2) = rows56(:,2)*0.25;
    rows56 = [0.56*ones(size(rows56,1),1),rows56];

    rows59 = [0.1, 0.3;
        0.2, 0.2;
        0.3, 0.3;
        0.5, 0.5;
        1, 0.5;
        2, 1;
        3, 1;
        5.5, 1;
        10, 3;
        20, 2;
        50, 5;
        100, 10];
    rows59(:,2) = rows59(:,2)*0.2;
    rows59 = [0.59*ones(size(rows59,1),1),rows59];

    Q_table = [rows44;rows48;rows52;rows56;rows59];

end