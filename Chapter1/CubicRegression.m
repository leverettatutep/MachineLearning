%% LinearRegression Script that demonstrates linear regression
% Fit a linear model to linear or quadratic data

%% Generate the data and perform the regression

x     = linspace(0,1,500)';
n     = length(x);

% Model a polynomial, y = ax2 + mx + b
a     = 1.0;     % quadratic - make nonzero for larger errors
m     = 1.0;     % slope
b     = 1.0;     % intercept
sigma = 0.1; % standard deviation of the noise
y0    = a*x.^2 + m*x + b;
y     = y0 + sigma*randn(n,1);

% Perform the linear regression using pinv
a     = [x ones(n,1)];
c     = pinv(a)*y;
yR    = c(1)*x + c(2); % the fitted line

sx = 0;
sxx = 0;
sxxx = 0;
sxxxx = 0;
sy = 0;
sxy = 0;
sxxy = 0;
sxxxy = 0;
for i=1:n
    sx = sx + x(i);
    sxx = sxx + x(i)^2;
    sxxx = sxxx + x(i)^3;
    sxxxx = sxxxx + x(i)^4;
        sy = sy + y(i);
    sxy = sxy + x(i)*y(i);
    sxxy = sxxy + x(i)^2 * y(i);
    sxxxy = sxxxy + x(i)^3 * y(i);
end
slope = sy*sxx - sx*sxy;
inter = n*sxy - sx*sy;
denom = n*sxx - sx^2;
slope = slope/denom
inter = inter/denom
yRl    = slope*x + inter; % the fitted line

denom = sxx*sxx*sxx - 2*sx*sxx*sxxx + n*sxxx*sxxx + sx*sx*sxxxx - n*sxx*sxxxx;
a0 = sxx*sxx*sxxy - sx*sxxx*sxxy - sxx*sxxx*sxy + sx*sxxxx*sxy + sxxx*sxxx*sy - sxx*sxxxx*sy;
a1 = -(sx*sxx*sxxy) + n*sxxx*sxxy + sxx*sxx*sxy - n*sxxxx*sxy - sxx*sxxx*sy + sx*sxxxx*sy;
a2 = sx*sx*sxxy - n*sxx*sxxy - sx*sxx*sxy + n*sxxx*sxy + sxx*sxx*sy - sx*sxxx*sy;
a0 = a0 / denom;
a1 = a1 / denom;
a2 = a2 / denom;
yRc = a0 + a1*x + a2*x.*x;

%% Generate plots
h = figure;
h.Name = 'Linear Regression';
plot(x,y); hold on;
plot(x,yR,'linewidth',2); hold on;
plot(x,yRc,'linewidth',2);
grid on
xlabel('x');
ylabel('y');
title('Linear Regression');
legend('Data','Fit')

figure('Name','Regression Error')
plot(x,yR-y0); hold on;
plot(x,yRc-y0);
grid on
xlabel('x');
ylabel('\Delta y');
title('Error between Model and Regression')
