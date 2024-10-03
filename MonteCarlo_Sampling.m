clear;
clc;
% number of simulation
num_simu = 100;

% parameters and v-cov matrix
l = [0.2187];
cov_matrix = [8.8526e-04];



% import data from CSV and convert to array

data_set= readtable('Air_tem.csv');

Time=table2array(data_set(:,1));
T=table2array(data_set(:,3));
u=table2array(data_set(:,4));

% emission prediction
predict_emission= @(T,u,l) equation1(T,u,l);

% initialize array to store emission predictions
emission_predictions = zeros (num_simu, length (T));

% Monte Carlo sampling and prediction

for i=1:num_simu
    sampled_params = mvnrnd(l, cov_matrix);
    
    emission_predictions (i,:)= predict_emission (T,u,sampled_params);
end 

% calculate mean and 95% percentiles

mean_emission = mean (emission_predictions,1);

percentiles_emission = prctile (emission_predictions, [2.5, 97.5],1);


Output = table (Time,mean_emission', percentiles_emission(1,:)', percentiles_emission (2,:)');
writetable (Output,'95% confidence interval.csv');

% Optional: plot the results
figure;
plot(Time, mean_emission, 'LineWidth', 2);
hold on;
plot(Time, percentiles_emission(1, :), 'r--', 'LineWidth', 1.5);
plot(Time, percentiles_emission(2, :), 'r--', 'LineWidth', 1.5);
xlabel('Time');
ylabel('Ammonia Emission (\mug/m^{2}/s)');
legend('Mean Emission', '95% CI Lower Bound', '95% CI Upper Bound');
title('Monte Carlo Simulation of Ammonia Emission');
grid on;


function y = equation1(T,u,l)
K_a = 10.^(0.05-2788./(T+273.15)); 
K_h = 0.2138./(T+273.15) .* 10.^(6.123-1825./(T+273.15));
h_m = 0.000612 .* u.^0.8 .* (T+273.15).^0.382 .* l^-0.2; % u, air velocity, m/s; L characteristic length, m
TAN = 400; % mg/L, g/m3
pH = 7.5;

y=h_m .* K_h * TAN .* 1./(1+10^(-pH)./K_a)*10^6;
end


