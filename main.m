% --------------------------------------------
%
%
% Written by Tingwu Wang
% 2015.5.29
%
%
%
%
% --------------------------------------------

% some basic parameters
delta_t = 1; % using the unit time slot
freq = 1 / delta_t; % the frequency is 1, arccordingly

% the amplitude and xiangwei
amp_db = [0 , -6, -8, -10];
amp = 10 .^ (amp_db / 20); 
time_delay = [0, 2, 5, 16];

% the response


% generate the input signal
input = rand(10000, 1);
input(input>0.5) = 1;
input(input<=0.5) = 0;

h = zeros(10000, 1);
% a sample of shenme shenme xiangying
for nPath = 1: 1: length(time_delay)
	% add the result
	h(time_delay(nPath) + 1) = h(time_delay(nPath) + 1) + amp(nPath);
end


% plot the homework1 results
figure(1)
subplot(2, 1, 1);
stem(h(1:20));
title('The time domain response')
ylabel('Normalized by the SNR')

subplot(2, 1, 2)
stem(log(h(1:20)))
ylabel('In dB, normalized by the SNR')
xlabel('The response h with time')

% transform into the grey code
input = grey(input);
input_qpsk = qpsk(input);
scatterplot(input_qpsk);
axis([-2 2 -2 2])


% get the results
receive_qpsk = filter(input_qpsk, 1, h);

% plot the results
scatterplot(receive_qpsk(1: 5000));
axis([-2 2 -2 2])

% decode the qpsk results
receive = iqpsk(receive_qpsk, 5000);


% ------------------------------------------------------------------


close all;
true_output = real(input_qpsk(1: 250));
raw_output = real(receive_qpsk(1: 250));
nWeight = 32;

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



