% visualise the fit
figure;
scatter3(T, u, J_NH3, 'MarkerEdgeColor', [142/255,85/255,179/255],'MarkerFaceColor', [142/255,85/255,179/255],'DisplayName', 'Measured', 'SizeData', 50);
hold on;
scatter3(T, u, predicted_emission, 'MarkerEdgeColor', [103/255,145/255,205/255],'DisplayName', 'Modelled', 'SizeData', 50);
xlabel('Temperature (°C)');
ylabel('Wind Speed (m/s)');
zlabel('Ammonia Emission (\mug/m^{2}/s)');
legend('Measured Data', 'Model Fit','Location', 'north','Box','off');
grid on;

set(gca, 'FontSize', 18);
set(gca, 'FontName', 'Arial');
set(gca, 'FontWeight', 'demi');
set(findall(gca,'Type','Text'),'Color','black');

% Set figure properties
fig = gcf; % Get current figure handle
fig.PaperUnits = 'inches'; % Set paper units to inches
fig.PaperPosition = [0 0 8 6]; % Set paper size to 8x6 inches (adjust as needed)
% Print figure to TIFF file with 300 dpi resolution
print('Tem_Air_Ammonia', '-dtiff', '-r600');