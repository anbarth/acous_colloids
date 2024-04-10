function Q_table = Q_tab_powerlaw(phi)
% Q table for k=1, interpolating onto the best fit power law
% my_const=0.1423;
% my_exp=-1.4530;

if phi == 0.44
    Q_table = [0.1, 0.5;
        0.2, 0.3;
        0.3, 1;
        0.5, 5;
        1, 10;
        2, 10;
        5, 40];
    Q_table(:,2) = Q_table(:,2)*1.2;
elseif phi == 0.48
    Q_table = [0.1, 0.01;
        0.2, 0.3;
        0.3, 0.5;
        0.5, 2;
        1, 10;
        2, 30;
        5, 100;
        10, 300];
    Q_table(:,2) = Q_table(:,2)*0.1;
elseif phi == 0.52
    Q_table = [0.1, 0.2;
        0.2, 0.2;
        0.3, 0.3;
        0.5, 1;
        1, 2;
        2, 3;
        5, 6;
        10, 15;
        20, 30];
    Q_table(:,2) = Q_table(:,2)*1;
elseif phi == 0.56
    Q_table = [0.1, 1;
        0.2, 0.3;
        0.3, 0.7;
        0.5, 0.8;
        1, 1.5;
        2, 3;
        5, 4;
        10, 5;
        20, 10;
        50, 50];
    Q_table(:,2) = Q_table(:,2)*0.25;
elseif phi == 0.59
    Q_table = [0.1, 0.3;
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
    Q_table(:,2) = Q_table(:,2)*0.2;
else
    Q_table = false;
    return
end

end