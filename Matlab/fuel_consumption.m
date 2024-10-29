close all;
clear;
clc;

power_df = readtable('power_data.csv');
sfc_df = readtable('sfc_data.csv');

fitted_power = polyfit(power_df.x , power_df.y , 2);
y1_fit = polyval(fitted_power, power_df.x);

fitted_sfc = polyfit(sfc_df.x , sfc_df.y , 9);
y2_fit = polyval(fitted_sfc, sfc_df.x);

figure;
hold on;
plot(power_df.x , power_df.y , 'DisplayName' , 'Primary power');
plot(power_df.x , y1_fit , 'DisplayName' , 'Fitted power curve');
plot(sfc_df.x , sfc_df.y , 'DisplayName' , 'Primary SFC');
plot(sfc_df.x , y2_fit , 'DisplayName' , 'Fitted SFC curve');
hold off;

legend('show');
title('SFC and Power - Rotational Speed of the Engine');
xlabel('Rotational Speed (rpm)');
set(legend, 'FontSize', 14);
grid on;
hold off;


speed = linspace(1000 , 7000 , 1000)';
N_t = [0.861 0.692];
N_tf = 3.777 * N_t;
r = 0.2653;
v1 = (r* speed * 2*pi) / (60 * N_tf(1));
v1 = v1 * 3.6;
v2 = (r* speed * 2*pi) / (60 * N_tf(2));
v2 = v2 * 3.6;
sfc = polyval(fitted_sfc , speed);
power = polyval(fitted_power , speed);
density = 742.9;
gears = {'4th gear', '5th gear'};

figure;

hold on;
output = ((sfc.*power) / density);
plot(v1 , output , 'DisplayName' , '4th gear');
plot(v2 , output , 'DisplayName' , '5th gear');

title('Fuel consumption - Velocity');
xlabel('Longitudinal velocity(km/h)');
ylabel('Fuel consumption(L/h)');
grid on;
legend('show');
set(legend , 'FontSize' , 14);
hold off;

slope1 = [];
slope2 = [];
% minimum slope
for i = 2:1000
    if v1(i) <= 156
        slope1 = [slope1 , (output(i) - output(i - 1)) / (v1(i) - v1(i - 1))];
    end
    if v2(i) <= 156
        slope2 = [slope2 , (output(i) - output(i - 1)) / (v2(i) - v2(i - 1))];
    end
end

velocity_index1 = find(slope1 == min(slope1)) + 1;
velocity_index2 = find(slope2 == min(slope2)) + 1;
message1 = sprintf('Minimum fuel consumption in 4th gear is %.3f L/km at velocity of %.3f km/h', min(slope1) , v1(velocity_index1));
disp(message1);
message2 = sprintf('Minimum fuel consumption in 5th gear is %.3f L/km at velocity of %.3f km/h', min(slope2) , v2(velocity_index2));
disp(message2);
