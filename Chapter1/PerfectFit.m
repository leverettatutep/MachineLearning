%% LinearRegression Script that demonstrates linear regression
% Fit a linear model to linear or quadratic data

%% Generate the data and perform the regression
clear 
close all
clc

n = 10;
x     = linspace(0,1,n)';
%n     = length(x);

% Model a polynomial, y = ax2 + mx + b
a     = 4.0;     % quadratic - make nonzero for larger errors
m     = 1.0;     % slope
b     = 1.0;     % intercept
sigma = 0.1; % standard deviation of the noise
y0    = a*x.^2 + m*x + b;
y     = y0 + sigma*randn(n,1);

% Perform the linear regression using pinv
a     = [x ones(n,1)];
c     = pinv(a)*y;

nn = 500;
xx = linspace(0,1,nn)';
yR    = c(1)*xx + c(2); % the fitted line
%nn = length(xx);
yy = xx;
for i=1:nn
    yy(i) = Lagrange(x,y,xx(i));
end

%% Generate plots
h = figure;
h.Name = 'Perfect Fit';
plot(x,y,'Marker','*'); hold on;
plot(xx,yy,'linewidth',2);
grid on
xlabel('x');
ylabel('y');
title('Perfect Fit');
legend('Data','Fit')

figure('Name','Regression Error')
plot(xx,yR-yy); 
grid on
xlabel('x');
ylabel('\Delta y');
title('Error between Model and Fit')

function TotalFun = Lagrange(x,y,thex)
n = length(x);
TotalFun = 0;
for k=1:n
    TotalFun = TotalFun + y(k) * LagrangeK(x,k,thex);
end
end

function Lk = LagrangeK(x,k,thex)
n = length(x);
Lk = 1;
for i=1:n
    if i ~= k
        Lk = Lk * (thex - x(i))/(x(k)-x(i));
    end
end
end