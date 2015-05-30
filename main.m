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
