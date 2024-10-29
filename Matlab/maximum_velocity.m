close all;
clear;
clc;

df = readtable('torque_data.csv');
torque = df.y * 9.81;
speed = df.x * ((2 * pi) / 60);
N_tf = 3.777 * 0.692;

%Single passenger
M1 = 1118;

figure;
hold on;

V_x1 = ((267.5 / 1000) * speed) / N_tf;
    
mass_factor = 1.04 + 0.0025 * N_tf^2;
M_r = mass_factor * M1 - M1;

drag = 0.5 * 1.184 * 2.34 * 0.35 * (V_x1 .^ 2);
R_x = 0.015 * M1 * 9.81 * ones(size(V_x1));
    
a_x = ((torque * ((N_tf * 0.85) / 0.2675)) - R_x - drag) / (M1 + M_r);
F_x = (torque * ((N_tf * 0.85) / 0.2675)) - (a_x * M_r);
F_r = R_x + drag;

V_x1 = V_x1 * 3.6;

% Find intersection
intersection_index = find(abs(F_x - F_r) == min(abs(F_x - F_r)));
intersection_velocity = V_x1(intersection_index);
intersection_force = F_x(intersection_index);

plot(V_x1, F_x, 'DisplayName', 'Tractive Force at the lowest gear ratio(5th gear)');
plot(V_x1 , F_r, 'DisplayName', 'Total Resistance - Velocity')

% Highlight intersection point
plot(intersection_velocity, intersection_force, 'ro', 'MarkerSize', 20, 'DisplayName', 'Intersection Point');
text(intersection_velocity, intersection_force, sprintf('  (%0.2f, %0.2f)', intersection_velocity, intersection_force),'FontSize', 10);

title('Force(Tractive and Total Resistance) - Velocity for Single-Passenger');
xlabel('Longitudinal Velocity (km/h)');
ylabel('Force (N)');
legend('show');
set(legend, 'FontSize', 14);
grid on;

hold off;

%Full load of passengers
M2 = 1425;

figure;
hold on;

V_x2 = ((265.3 / 1000) * speed) / N_tf;

M_r2 = mass_factor * M2 - M2;

drag_2 = 0.5 * 1.184 * 2.34 * 0.35 * (V_x2 .^ 2);
R_x2 = 0.015 * M2 * 9.81 * ones(size(V_x2));
    
a_x2 = ((torque * ((N_tf * 0.85) / 0.2653)) - R_x2 - drag_2) / (M2 + M_r2);
F_x2 = (torque * ((N_tf * 0.85) / 0.2653)) - (a_x2 * M_r2);
F_r2 = R_x2 + drag_2;

V_x2 = V_x2 * 3.6;

% Find intersection
intersection_index_2 = find(abs(F_x2 - F_r2) == min(abs(F_x2 - F_r2)));
intersection_velocity_2 = V_x2(intersection_index_2);
intersection_force_2 = F_x2(intersection_index_2);

plot(V_x2, F_x2, 'DisplayName', 'Tractive Force at the lowest gear ratio(5th gear)');
plot(V_x2 , F_r2, 'DisplayName', 'Total Resistance - Velocity')

% Highlight intersection point
plot(intersection_velocity_2, intersection_force_2, 'ro', 'MarkerSize', 20, 'DisplayName', 'Intersection Point');
text(intersection_velocity_2, intersection_force_2, sprintf('  (%0.2f, %0.2f)', intersection_velocity_2, intersection_force_2),'FontSize', 10);

title('Force(Tractive and Total Resistance) - Velocity for full load of passengers');
xlabel('Longitudinal Velocity (km/h)');
ylabel('Force (N)');
legend('show');
set(legend, 'FontSize', 14);
grid on;

hold off;