% ------------------------------------------------
%
%   remote sensing homework
%   Written by Tingwu Wang
%
%   6.6.2015
%
% ------------------------------------------------

clear, clc;
% variables to record for results
matrixDim = 3;
timeBrute = 0;
timePoly = 0;
timeVieta = 0;

polyDelta = 0;
VietaDelta = 0;

% get the parameters of fitting
xdata = linspace(0.001, 1, 10000);
ydata = - xdata .* log(xdata) / log(3);
F = @(g,xdata) g(1) + g(2) * xdata + g(3) * xdata.^2 + g(4) * xdata.^3;
g = lsqcurvefit(F, [0 0 0 0], xdata, ydata);


for iMatrix = 1: 1: 10000
    % generating a random semipositive matrix
    X = diag(rand(matrixDim, 1));
    U = orth(rand(matrixDim, matrixDim));
    tMatrix = U' * X * U;
    
    % the brute force algorithm
    tstart = tic;

    eigenVec = eig(tMatrix);
    eigenVec = eigenVec / sum(eigenVec);
    H0 = -1 * sum(eigenVec .* log(eigenVec)) / log(3);
    
    timeBrute = timeBrute + toc(tstart);
    
    
    % the using the poly fitting algorithm
    tstart = tic;

    eigenVec = eig(tMatrix);
    eigenVec = eigenVec / sum(eigenVec);
    H = sum(F(g, eigenVec));
    
    timePoly = timePoly + toc(tstart);
    polyDelta = polyDelta + abs(H0 - H) / H0;
    
    % the using the poly fitting algorithm with vieta
    tstart = tic;
    
    % getting the vieta coefficient
    a = 1;
    b = - (tMatrix(1,1) + tMatrix(2,2) + tMatrix(3,3));
    c = tMatrix(1,1) * tMatrix(2,2) + tMatrix(1,1) * tMatrix(3,3) + ...
        tMatrix(2,2) * tMatrix(3,3) - tMatrix(1,2) * tMatrix(1,2) - ...
        tMatrix(1,3) * tMatrix(1,3) - tMatrix(2,3) * tMatrix(2,3);
    d = -det(tMatrix);

    % F = @(g,xdata) g(1) + g(2) * xdata + g(3) * xdata.^2 + g(4) * xdata.^3;
    H = 3 * g(1) + g(2) * 1 + g(3) * (1 - 2 * a * c / b / b) + ...
        g(4) * (1 + 3 * d * a^2 / b^3 - 3 * a * c / b / b);
    timeVieta = timeVieta + toc(tstart);
    VietaDelta = VietaDelta + abs(H0 - H) / H0;
    
end

polyDelta = polyDelta / 10000;
VietaDelta = VietaDelta / 10000;