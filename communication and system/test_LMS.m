
raw_output = randint(500, 1);
true_output = randint(500, 1);
nWeight = 32;

% raw_output -> x, true_output -> y, y_i = \sum(xTw)

% initialize the weight factor
weight = zeros(nWeight, 1);
weight(1) = 1;

mu = 0.1;
c0 = 0.01;
mu_unified = mu / (c0 + sum(raw_output' * raw_output) ...
	/ nWeight);
% append nWeight zeros to enable the calculations
raw_output = [zeros(nWeight, 1); raw_output];

% loop until convergence
while 1
	% renew the raw output
	predict_output = zeros(length(true_output), 1);
	for iWeight = 1: 1: nWeight
		predict_output = predict_output + weight(iWeight) * raw_output(iWeight: length(true_output) + iWeight - 1);
	end

	% get the error of the target function
	target_error = true_output - predict_output;
    fprintf('The overall error is now %f\n', sum(target_error' * target_error));
	if sum(target_error' * target_error) < 1e-2
		break
	end

	for iWeight = 1: 1: nWeight
		% get the unifying descedent steps and decent
		descent = target_error' * raw_output(iWeight: length(true_output) + iWeight - 1);
		weight(iWeight) = weight(iWeight) + 2 * mu_unified * descent;
	end
end
