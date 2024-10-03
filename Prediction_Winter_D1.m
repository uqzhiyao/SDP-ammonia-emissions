% Import data from CSV files

Winter1_data = readtable ('Winter-1.csv');

% Extract data from tables

Time = Winter1_data (:,1);
J_NH3 = Winter1_data(:,2);

u = Winter1_data(:,3);

T = Winter1_data(:,5);

% combine data into a single matrix

data_matrix1 = [Time,J_NH3];
data_matrix2= [Time, u,T,J_NH3];

% Remove rows with any missing values

data_matrix2 = rmmissing (data_matrix2);

% separate the cleaned data
Time1 = table2array(data_matrix1 (:, 1));
J_NH3 = table2array(data_matrix1 (:,2));
Time2 = table2array(data_matrix2 (:, 1));
u = table2array(data_matrix2 (:,2));
T = table2array(data_matrix2 (:,3));
J_NH3_clean=table2array(data_matrix2 (:,4));

%calculate ammonia emission based on T and u

model_function= @(T,u,l) equation1(T,u,l);

objective_function=@(l) sum((J_NH3_clean-model_function(T,u,l)).^2);

initial_guess = [1000];

optimal_params =fminsearch (objective_function, initial_guess);

disp(optimal_params);

predicted_emission=model_function (T,u,optimal_params);

SS_res = sum ((J_NH3_clean-predicted_emission).^2);
SS_tot = sum ((J_NH3_clean-mean(J_NH3)).^2);
R_squared = 1-(SS_res/SS_tot);

disp (R_squared);
% visualization
figure;
plot(Time1, J_NH3, 'bo', 'MarkerFaceColor', 'b', 'DisplayName', 'Measured');
hold on;
plot(Time2, predicted_emission, 'r-', 'LineWidth', 2, 'DisplayName', 'Modelled');
legend('Measured', 'Modelled');


function y = equation1(T,u,l)
K_a = 10.^(0.05-2788./(T+273.15)); 
K_h = 0.2138./(T+273.15) .* 10.^(6.123-1825./(T+273.15));
h_m = 0.000612 .* u.^0.8 .* (T+273.15).^0.382 .* l^-0.2; % u, air velocity, m/s; L characteristic length, m
TAN = 879; % mg/L, g/m3
pH = 7.5;

y=h_m .* K_h * TAN .* 1./(1+10^(-pH)./K_a)*10^6;
end