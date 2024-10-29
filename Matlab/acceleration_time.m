close all;
clear;
clc;

df = readtable('torque_data.csv');
torque = df.y * 9.81;
speed = df.x * ((2 * pi) / 60);
N_t = [3.454 1.944 1.275];

%Single passenger
N_tf = 3.777 * N_t;
M1 = 1118;
gears = {'1st gear', '2nd gear', '3rd gear'};

figure;
hold on;

% Loop through each value of N_tf
time = 0;
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

    % Plot the current set of data
    plot(V_x1, 1./a_x, 'DisplayName', gears{i});
    if i == 1
        index = 1;
        while V_x1(index) < 12
            index = index + 1;
        end
        x = V_x1(1:index);
        time = time + trapz(x , 1./a_x(1:index));
        
    elseif i == 2
        start_index = 1;
        end_index = 1;
        while V_x1(start_index) < 12
            start_index = start_index + 1;
        end
        while V_x1(end_index) < 22
            end_index = end_index + 1;
        end
        x = V_x1(start_index:end_index);
        time = time + trapz(x , 1./a_x(start_index:end_index));
    
    else
        start_index = 1;
        end_index = 1;
        while V_x1(start_index) < 22
            start_index = start_index + 1;
        end
        while V_x1(end_index) < 100/3.6
            end_index = end_index + 1;
        end
        x = V_x1(start_index:end_index);
        time = time + trapz(x , 1./a_x(start_index:end_index));
    end

end
message = sprintf('Zero to 100 (km/h) acceleration time is %.2f seconds', time);
disp(message);

% Title and axis labels
title('1/a(V) - Velocity for 1st, 2nd & 3rd Gear Ratios (Single-Passenger)');
xlabel('Longitudinal Velocity (m/s)');
ylabel('1/a (s^2/m)');
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
time = 0;
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
    
    % Plot the current set of data
    plot(V_x2, 1./a_x2, 'DisplayName', gears{i});
    if i == 1
        index = 1;
        while V_x2(index) < 12
            index = index + 1;
        end
        x = V_x2(1:index);
        time = time + trapz(x , 1./a_x2(1:index));
        
    elseif i == 2
        start_index = 1;
        while V_x2(start_index) < 12
            start_index = start_index + 1;
        end
        x = V_x2(start_index:65);
        time = time + trapz(x , 1./a_x2(start_index:65));
    
    else
        start_index = 1;
        end_index = 1;
        while V_x2(start_index) < 22
            start_index = start_index + 1;
        end
        while V_x2(end_index) < 100/3.6
            end_index = end_index + 1;
        end
        x = V_x2(start_index:end_index);
        time = time + trapz(x , 1./a_x2(start_index:end_index));
    end
end
message = sprintf('Zero to 100 (km/h) acceleration time is %.2f seconds', time);
disp(message);

% Title and axis labels
title('1/a(V) - Velocity for 1st, 2nd & 3rd Gear Ratios (Full load of passengers)');
xlabel('Longitudinal Velocity (m/s)');
ylabel('1/a (s^2/m)');
legend('show');
set(legend, 'FontSize', 14);
grid on;

% Release hold on the current plot
hold off;