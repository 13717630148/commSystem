function output = blind_LMS(input)
% averaging to get a fine result
output_size = length(input) / 2;

output = zeros(output_size, 1);
output(:) = input(1 : output_size) + input(end: -1: end - output_size + 1);
output = output / 2;

