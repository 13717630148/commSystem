% -------------------------------------------------------------------------------- %
% It is the project for the course "communication and network" simulating
% the capacity of a certain channel
%
% Written by Tingwu Wang, Tsinghua University, for the course project
% 27/09/2015
% -------------------------------------------------------------------------------- %

% In the function, the A is set as "1" for convenience and the noise is set
% as "sigma2" as a relative parameters, note here the s2 is the standard
% variantion, instead of its square
A = 1;
sigma2 = 0:0.1:30;
%sigma2 = 10.^(sigma2);
M = 1:3;

bound_interval = 3; % in the numerical calculation, we consider the 3-sigma
                   % interval in the gaussian distribution

entropy_y = zeros(length(M), length(sigma2), 1);

for i_M = 1: 1: length(M)
    for i_variation = 1: 1: length(sigma2)
        entropy_y(i_M, i_variation) = ...
            integral(@(x)entropy_type1(x, M(i_M), sigma2(i_variation)), ...
            0 - 3 * sigma2(i_variation), 3 * sigma2(i_variation) + M(i_M));
        entropy_y(i_M, i_variation) = ...
            entropy_y(i_M, i_variation) - ...
            1 / 2 * log2(2 * pi * exp(1) * sigma2(i_variation)^2);
        fprintf('i_M = %f, s2 = %f\n', i_M, sigma2(i_variation))
    end
    fprintf('The %d th line finished\n', i_M)
end

% plot the results
legend_name = cell(length(M) + 1, 1);
cmap = hsv(length(M) + 1);  % Creates a 6-by-3 set of colors from the HSV colormap
for i_M = 1: 1: length(M)
  plot(sigma2, entropy_y(i_M, :), 'Color', cmap(i_M, :));
  hold on;
  box on;
  grid on;
  legend_name{i_M} = ['M = ' num2str(i_M)];
end

% awgn channel
awgn_entropy = zeros(1, length(sigma2));

for i_variation = 1: 1: length(sigma2)
    awgn_entropy(i_variation) = 1 / 2 * log2(1 + 1 / sigma2(i_variation));
end
legend_name{length(M) + 1} = 'AWGN';
plot(sigma2, awgn_entropy(:), 'Color', cmap(length(M) + 1, :));
legend(legend_name)
