% ------------------------------------------------
%   remote sensing homework
%   Written by Tingwu Wang
%   
%   6.6.2015
%
% ------------------------------------------------


% the original one
xdata = linspace(0.001, 1, 10000);
ydata = xdata .* log(xdata);
plot(xdata, ydata, 'm')
hold on;

tstart = tic;
% using the n parameter as 3
F = @(g,xdata) g(1) + g(2) * xdata + g(3) * xdata.^2 + g(4) * xdata.^3;
g = lsqcurvefit(F, [0 0 0 0], xdata, ydata);
plot(xdata, F(g, xdata), 'b')
telapsed3 = toc(tstart);

tstart = tic;
% using the n parameter as 4
F = @(g,xdata) g(1) + g(2) * xdata + g(3) * xdata.^2 + g(4) * xdata.^4;
g = lsqcurvefit(F, [0 0 0 0], xdata, ydata);
plot(xdata, F(g, xdata), 'g')
telapsed4 = toc(tstart);

tstart = tic;
% using the n parameter as 5
F = @(g,xdata) g(1) + g(2) * xdata + g(3) * xdata.^2 + g(4) * xdata.^5;
g = lsqcurvefit(F, [0 0 0 0], xdata, ydata);
plot(xdata, F(g, xdata), 'r')
telapsed5 = toc(tstart);

tstart = tic;
% using the n parameter as 6
F = @(g,xdata) g(1) + g(2) * xdata + g(3) * xdata.^2 + g(4) * xdata.^6;
g = lsqcurvefit(F, [0 0 0 0], xdata, ydata);
plot(xdata, F(g, xdata), 'c')
telapsed6 = toc(tstart);

grid on
box on
legend('original', ['n = 3, t= ' num2str(telapsed3)], ...
    ['n = 4, t= ' num2str(telapsed4)], ['n = 5, t= ' num2str(telapsed5)], ...
    ['n = 6, t= ' num2str(telapsed6)]);