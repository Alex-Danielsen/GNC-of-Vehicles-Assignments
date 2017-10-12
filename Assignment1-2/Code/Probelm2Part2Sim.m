clear all
close all

h = .001;
time = 0:h:1000;

R = 100;

U = 1.5;
omega = 150;
x = zeros(size(time));
y = zeros(size(time));

x(1) = 0;
y(1) = -100;

for i = 2:length(time)
    t = time(i);
    dx = U*cos(omega*t);
    dy = U*sin(omega*t);
    
    
    x(i) = x(i-1) + dx;
    y(i) = y(i-1) + dy;
    
end

plot(x, y, '-m')
hold on
plot(R*cos(.015*time), R*sin(.015*time), '-b')