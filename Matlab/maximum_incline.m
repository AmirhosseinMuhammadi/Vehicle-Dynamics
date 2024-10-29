close all;
clear;
clc;

df = readtable('torque_data.csv');
df.y = df.y * 9.81;

p = polyfit(df.x, df.y, 5);

N_t = [3.454 1.944 1.275 0.861 0.692];
N_tf = 3.777 * N_t;

output = [];
for i = 1:length(N_tf)
    omega = (5 * N_tf(i)*60) / (7.2*0.2653*pi);
    drag = 0.5 * 1.184 * 2.34 * 0.35 * (5/3.6) ^ 2;
    torque = polyval(p, omega);
    value = ((torque * N_tf(i)* 0.85) / 0.2653 - drag) / (1425*9.81);
    output = [output,value];
end

theta = linspace(0 , 0.5*pi , 100);
y = 0.015 * cos(theta) + sin(theta);
hold on;
plot(theta , y , 'DisplayName' , 'Trigonometric curve');
title('Trigonometric curve and the corresponding value based on the gear ratio');
ylabel('\mu cos(\theta) + sin(\theta)');
xlabel('theta(incline of the road) in radian');

gears = {'1st gear', '2nd gear', '3rd gear', '4th gear', '5th gear'};
for i = 1:5
    y2 = output(i) * ones(100,1);
    plot(theta , y2 , 'DisplayName', gears{i});
end

legend('show');
set(legend, 'FontSize', 14);
grid on;
hold off;
