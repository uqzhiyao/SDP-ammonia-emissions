
% Import data from CSV files

Winter1_data = readtable ('Winter-1.csv');

% Extract data from tables

J_NH3 = Winter1_data(:,1);

u = Winter1_data(:,2);

T = Winter1_data(:,4);

% combine data into a single matrix

data_matrix = [J_NH3,u,T];

% Remove rows with any missing values

data_matrix = rmmissing (data_matrix);

% separate the cleaned data
T = data_matrix (:, 3);
u = data_matrix (:,2);
J_NH3 = data_matrix (:,1);

% Table to array
T=table2array(T(:,1));
u=table2array(u(:,1));
J_NH3=table2array(J_NH3(:,1));

% Visualization
[temGrid,airGrid] = meshgrid(linspace(10,25), linspace (1,6));

figure;
scatter3(T, u, J_NH3, 96);
xlabel('Temperature (°C)');
ylabel('Air Velocity (m/s)');
zlabel('Ammonia Flux (ug/m2/s)');
title('Ammonia emission versus Temperatuer and Air velocity');
grid on;


