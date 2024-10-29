close all;
clear;
clc;

df = readtable('torque_data.csv');
df.y = df.y * 9.81;

plot(df.x, df.y, 'o-', 'DisplayName', 'Original Data'); 
hold on;

p = polyfit(df.x, df.y, 5);
y_fit = polyval(p, df.x);

plot(df.x, y_fit, '-', 'DisplayName', '5th Degree Polynomial Fit');

title('Torque - Rotational Speed of the Engine');
xlabel('Rotational Speed (rpm)');
ylabel('Torque (N.m)');

grid on;

legend('show');
set(legend, 'FontSize', 14);
hold off;

%Single passenger
torque = df.y;
speed = df.x * ((2 * pi) / 60);
N_t = [3.454 1.944 1.275 0.861 0.692];
N_tf = 3.777 * N_t;
M1 = 1118;
gears = {'1st gear', '2nd gear', '3rd gear', '4th gear', '5th gear'};

figure;
hold on;

% Loop through each value of N_tf
for i = 1:length(N_tf)
    % Calculate V_x1 for the current N_tf
    V_x1 = ((267.5 / 1000) * speed) / N_tf(i);
    
    % Calculate the mass factor and adjusted mass
    mass_factor = 1.04 + 0.0025 * N_tf(i)^2;
    M_r = mass_factor * M1 - M1;
    
    % Calculate drag force and rolling resistance
    drag = 0.5 * 1.184 * 2.34 * 0.35 * (V_x1 .^ 2);
    R_x = 0.015 * M1 * 9.81 * ones(size(V_x1));
    
    % Calculate acceleration and resulting force
    a_x = ((torque * ((N_tf(i) * 0.85) / 0.2675)) - R_x - drag) / (M1 + M_r);
    F_x = (torque * ((N_tf(i) * 0.85) / 0.2675)) - (a_x * M_r);
    
    % Convert V_x1 to km/h
    V_x1 = V_x1 * 3.6;
    
    % Plot the current set of data
    plot(V_x1, F_x, 'DisplayName', gears{i});
end

% Title and axis labels
title('Tractive Force - Velocity for Various Gear Ratios (Single-Passenger)');
xlabel('Longitudinal Velocity (km/h)');
ylabel('Tractive Force (N)');
legend('show');
set(legend, 'FontSize', 14);
grid on;

% Release hold on the current plot
hold off;

% Full load of passengers
M2 = 1425;

figure;
hold on;

% Loop through each value of N_tf
for i = 1:length(N_tf)
    % Calculate V_x1 for the current N_tf
    V_x2 = ((265.3 / 1000) * speed) / N_tf(i);
    mass_factor_2 = 1.04 + 0.0025 * N_tf(i)^2;
    M_r2 = mass_factor_2 * M2 - M2;
    
    % Calculate drag force and rolling resistance
    drag_2 = 0.5 * 1.184 * 2.34 * 0.35 * (V_x2 .^ 2);
    R_x2 = 0.015 * M2 * 9.81 * ones(size(V_x2));
    
    % Calculate acceleration and resulting force
    a_x2 = ((torque * ((N_tf(i) * 0.85) / 0.2653)) - R_x2 - drag_2) / (M2 + M_r2);
    F_x2 = (torque * ((N_tf(i) * 0.85) / 0.2653)) - (a_x2 * M_r2);
    
    % Convert V_x1 to km/h
    V_x2 = V_x2 * 3.6;
    
    % Plot the current set of data
    plot(V_x2, F_x2, 'DisplayName', gears{i});
end

% Title and axis labels
title('Tractive Force - Velocity for Various Gear Ratios (Full load of passengers)');
xlabel('Longitudinal Velocity (km/h)');
ylabel('Tractive Force (N)');
legend('show');
set(legend, 'FontSize', 14);
grid on;

% Release hold on the current plot
hold off;
