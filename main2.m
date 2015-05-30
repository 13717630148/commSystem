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
amp_db = [0 , -6, -8, -10];
amp = 10 .^ (amp_db / 20); 
time_delay = [0, 2, 5, 16];
nWeight = 32;
nError = zeros(15, 1);

% the noise 
noise = (rand(10500, 1) * 2) .* exp(1j * rand(10500, 1) * 2 * pi);

for iDb = 1: 15
    % generate the input signal
    input = rand(10500, 1);
    input(input>0.5) = 1;
    input(input<=0.5) = 0;
    
    % the response
    input_grey = grey(input);
    input_qpsk = qpsk(input_grey);
    
    h = zeros(10500, 1);
    % a sample of shenme shenme xiangying
    for nPath = 1: 1: length(time_delay)
        % add the result
        h(time_delay(nPath) + 1) = h(time_delay(nPath) + 1) + amp(nPath);
    end
    
    % get the results, remember to add the noise
    receive_qpsk_withHeader = filter(input_qpsk, 1, h);
    receive_qpsk_withHeader = receive_qpsk_withHeader + noise /(10.^(iDb / 20));
    
    receive_qpsk = receive_qpsk_withHeader(251 : end);
    
    % get the LMS filter weight
    real_weight = LMS(real(receive_qpsk_withHeader(1 : 250)), real(input_qpsk(1: 250)), nWeight);
    imag_weight = LMS(imag(receive_qpsk_withHeader(1 : 250)), imag(input_qpsk(1: 250)), nWeight);
    
    % get the filtered results
    predict_qpsk = zeros(5000, 1);
    receive_qpsk = [zeros((nWeight) - 1, 1); receive_qpsk];
    for iWeight = 1: 1: nWeight
        predict_qpsk = predict_qpsk + real_weight(iWeight) * real(receive_qpsk(iWeight: length(predict_qpsk) + iWeight - 1));
        predict_qpsk = predict_qpsk + 1i * imag_weight(iWeight) * imag(receive_qpsk(iWeight: length(predict_qpsk) + iWeight - 1));
    end
    
    % plot the results
    scatterplot(receive_qpsk(1: 5000));
    axis([-2 2 -2 2])
    
    scatterplot(predict_qpsk(1: 5000));
    axis([-2 2 -2 2])
    
    % decode the qpsk results
    receive_grey = iqpsk(predict_qpsk, 5000);
    receive = igrey(receive_grey);
    nError(iDb) = sum(abs(receive - input(501: end)));
    fprintf('The %d comes with %f errors \n', iDb, nError(iDb) / 10000);
end

