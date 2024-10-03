clear;
clc;

% import data from CSV and convert to array

data_set= readtable('Air_tem.csv');

Time=table2array(data_set(:,1));
T=table2array(data_set(:,3));
u=table2array(data_set(:,4));

model_function= @(T,u) equation1(T,u);

predicted_emission=model_function (T,u);

% visualization
figure;

plot(Time, predicted_emission, 'bo', 'MarkerFaceColor', 'b', 'DisplayName', 'Modelled');

average_value=mean(predicted_emission);

disp(num2str(average_value));

Output = table (Time,predicted_emission);
writetable (Output,'predicted_weekly_ammonia_emission.csv');

function y = equation1(T,u,l)
l=0.2187;
K_a = 10.^(0.05-2788./(T+273.15)); 
K_h = 0.2138./(T+273.15) .* 10.^(6.123-1825./(T+273.15));
h_m = 0.000612 .* u.^0.8 .* (T+273.15).^0.382 .* l^-0.2; % u, air velocity, m/s; L characteristic length, m
TAN = 400; % mg/L, g/m3
pH = 7.5;

y=h_m .* K_h * TAN .* 1./(1+10^(-pH)./K_a)*10^6;
end