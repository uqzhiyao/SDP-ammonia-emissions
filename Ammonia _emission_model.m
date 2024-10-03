% determining h_m, K_h, and K_a
l; % the parameter to be fitted

K_a = 10^(0.05-2788/T); % T, temperature, K

K_h = 0.2138/T * 10^(6.123-1825/T);

h_m = 0.00612 * u^0.8 * T^0.382 * l^-0.2; % u, air velocity, m/s; L characteristic length, m

% measured data

TAN = 879;

% Theoretical model for mass transfer of ammonia

J_NH3=h_m * ammonia_gas; % h_m: mass transfer efficient, m/s

ammonia_gas = K_h * ammonia_aqu; % henry's law, ammonia concentration in gas and liquid, g N/m3

ammonia_aqu = [TAN] * 1/(1+10^(-pH)/K_a); % TAN, total ammonia in liquid; K_a, ammonia disassociation constant

