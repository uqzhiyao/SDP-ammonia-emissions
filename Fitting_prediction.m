clear;
clc;

% import data from CSV and convert to array

data_set= readtable('Ammonia_emission_fit.csv');

T=table2array(data_set(:,1));
u=table2array(data_set(:,2));
J_NH3=table2array(data_set(:,3));

%Define model function

% determining h_m, K_h, and K_a


model_function= @(T,u,l) equation1(T,u,l);

objective_function=@(l) sum((J_NH3-model_function(T,u,l)).^2);

initial_guess = [1];

optimal_params =fminsearch (objective_function, initial_guess);

disp(optimal_params);

predicted_emission=model_function (T,u,optimal_params);

% calculated R2
SS_res = sum ((J_NH3-predicted_emission).^2);
SS_tot = sum ((J_NH3-mean(J_NH3)).^2);
R_squared = 1-(SS_res/SS_tot);
disp (R_squared);

% calculated RMSE
residuals = J_NH3-predicted_emission;
squared_residuals=residuals .^ 2;
mean_squared_residuals=mean(squared_residuals);
rmse= sqrt(mean_squared_residuals);

disp(num2str(rmse));


% prediction under different scenarios
% temperature 10-25 degree, wind speed 0-6 m/s
scenario_temp=linspace(5,35,30);
scenario_wind_speed=linspace(0.1,6,30);
[scenarioTempGrid,scenarioWindSpeedGrid]=meshgrid(scenario_temp,scenario_wind_speed);

predicted_emission_grid=model_function(scenarioTempGrid,scenarioWindSpeedGrid,optimal_params);

% calculate the jacobian matrix
jacobian = jacobianest(@(l) model_function(T, u, l), optimal_params);

% estimate the variance of residuals
residual_variance = var (residuals);

% compute the variance-covariance matrix
cov_matrix = residual_variance * inv(jacobian' * jacobian);

disp('Variance-Covariance Matrix:');
disp(cov_matrix);


% visualization
figure;
surf(scenarioTempGrid,scenarioWindSpeedGrid,predicted_emission_grid, 'EdgeColor','none');
xlabel('Temperature (°C)');
ylabel('Wind Speed (m/s)');
zlabel('Ammonia Emission (\mug/m^{2}/s)');
grid on;

% Define two specific RGB colors
color2 = [142/255, 85/255, 179/255]; % First color
color1 = [103/255, 145/255, 205/255]; % Second color

% Create a colormap that interpolates between the two colors
num_colors = 256; % Number of colors in the colormap
colormap_matrix = [linspace(color1(1), color2(1), num_colors)', ...
                   linspace(color1(2), color2(2), num_colors)', ...
                   linspace(color1(3), color2(3), num_colors)'];

% Apply the custom colormap
colormap(colormap_matrix);
colorbar; % Add a colorbar for reference

set(gca, 'FontSize', 18);
set(gca, 'FontName', 'Arial');
set(gca, 'FontWeight', 'Demi');
set(findall(gca,'Type','Text'),'Color','black');

% Set figure properties
fig = gcf; % Get current figure handle
fig.PaperUnits = 'inches'; % Set paper units to inches
fig.PaperPosition = [0 0 8 6]; % Set paper size to 8x6 inches (adjust as needed)
% Print figure to TIFF file with 300 dpi resolution
print('Prediction', '-dtiff', '-r600');

function y = equation1(T,u,l)
K_a = 10.^(0.05-2788./(T+273.15)); 
K_h = 0.2138./(T+273.15) .* 10.^(6.123-1825./(T+273.15));
h_m = 0.000612 .* u.^0.8 .* (T+273.15).^0.382 .* l^-0.2; % u, air velocity, m/s; L characteristic length, m
TAN = 879; % mg/L, g/m3
pH = 7.5;

y=h_m .* K_h * TAN .* 1./(1+10^(-pH)./K_a)*10^6;
end

function jacobian = jacobianest(func, params)
    n = numel(params);
    m = numel(func(params));
    jacobian = zeros(m, n);
    delta = 1e-6;  % Finite difference step size
    for i = 1:n
        params_forward = params;
        params_backward = params;
        params_forward(i) = params_forward(i) + delta;
        params_backward(i) = params_backward(i) - delta;
        jacobian(:, i) = (func(params_forward) - func(params_backward)) / (2 * delta);
    end
end
