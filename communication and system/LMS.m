function weight = LMS(raw_output, true_output, nWeight)
% raw_output -> x, true_output -> y, y_i = \sum(xTw)

% initialize the weight factor
weight = zeros(nWeight, 1);
weight(nWeight) = 1;

mu = 0.001;
c0 = 0.01;
mu_unified = mu / (c0 + sum(raw_output' * raw_output) ...
    / nWeight);
% append nWeight zeros to enable the calculations
raw_output = [zeros(nWeight - 1, 1); raw_output];

% loop until convergence
lastTimeError = 0;
recordError = zeros(1000, 1);
count = 1;

while 1
    % renew the raw output
    predict_output = zeros(length(true_output), 1);
    for iWeight = 1: 1: nWeight
        predict_output = predict_output + weight(iWeight) * raw_output(iWeight: length(true_output) + iWeight - 1);
    end
    
    % get the error of the target function
    target_error = true_output - predict_output;
    
    % break if stoped
    if abs(sum(target_error' * target_error) - lastTimeError) < 0.01
        break
    end
    
    lastTimeError = sum(target_error' * target_error);
    if count <= 10000
        recordError(count) = lastTimeError;
        count = count + 1;
    end
    fprintf('The overall error is now %f\n', lastTimeError);
    
    for iWeight = 1: 1: nWeight
        % get the unifying descedent steps and decent
        descent = target_error' * raw_output(iWeight: length(true_output) + iWeight - 1);
        weight(iWeight) = weight(iWeight) + 2 * mu_unified * descent;
    end
end
%figure(3)
%plot(recordError(1: count - 1));
%title('The error during the training')
%box on
%grid on


