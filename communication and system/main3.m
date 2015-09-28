% --------------------------------------------
%
% Written by Tingwu Wang
% 2015.5.29
%
% --------------------------------------------

% some basic parameters
delta_t = 1; % using the unit time slot
freq = 1 / delta_t; % the frequency is 1, arccordingly

% the amplitude and xiangwei
amp_db = [0 , -16, -18, -20];
amp = 10 .^ (amp_db / 20); 
time_delay = [0, 2, 5, 16];
nWeight = 32;
nError = zeros(15, 1);

% the noise 
noise = (rand(20000, 1) * 2) .* exp(1j * rand(20000, 1) * 2 * pi);

for iDb = 1: 15
    % generate the input signal
    input = rand(10000, 1);
    input(input>0.5) = 1;
    input(input<=0.5) = 0;
	input = [input; input(end: -1: end - 10000 + 1)];
    
    % the response
    input_grey = grey(input);
    input_qpsk = qpsk(input_grey);
    
    h = zeros(20000, 1);
    % a sample of shenme shenme xiangying
    for nPath = 1: 1: length(time_delay)
        % add the result
        h(time_delay(nPath) + 1) = h(time_delay(nPath) + 1) + amp(nPath);
    end
    
    % get the results, remember to add the noise
    receive_qpsk_withHeader = filter(input_qpsk, 1, h);
    receive_qpsk  = receive_qpsk_withHeader + noise /(10.^(iDb / 20));
    
    % get the blind LMS filtered results
    predict_qpsk = zeros(5000, 1);
	predict_qpsk = blind_LMS(receive_qpsk);
    
    % plot the results
    scatterplot(receive_qpsk(1: 5000));
    axis([-2 2 -2 2])
    
    scatterplot(predict_qpsk(1: 5000));
    axis([-2 2 -2 2])
    
    % decode the qpsk results
    receive_grey = iqpsk(predict_qpsk, 5000);
    receive = igrey(receive_grey);
    nError(iDb) = sum(abs(receive - input(1: 10000)));
    fprintf('The %d comes with %f errors \n', iDb, nError(iDb) / 10000);
end

