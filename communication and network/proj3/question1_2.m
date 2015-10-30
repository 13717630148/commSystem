
clear all; close all;
figure;
i = 0;
for prob = 1: -0.2: 0
    i = i + 1;
    N = 1001;   % sample 1000 points, 1 is added as the initial source
    T = 1;  % the time period is 1 s
    sampleRate = 8;
    
    pobability = rand(1,N);
    source = zeros(1,N);
    
    source(pobability > prob) = 1;  % generate the source
    source(1) = 1;
    
    t = 0: 1/sampleRate/N: T - 1/sampleRate/N;
    
    % The AMI results
    f = zeros(1, N);
    AMI = zeros(1, N * sampleRate);
    
    for k = 2 : 1: 1000
        f(k) = mod((f(k-1) + source(k)), 2);  % generate the f
    end
    send = zeros(1, N);
    for k = 1 : 1: N
        if(source(k)==0)
            send(k) = 0;
        elseif(f(k) == 1)
            send(k) = 1;
        else
            send(k) = -1;
        end
        AMI((k - 1) * sampleRate + 2 : k * sampleRate - 3) = send(k);
    end
    subplot(2, 3, i)
    SPower_AMI = 1 / length(AMI) * abs(fft(AMI)) .^ 2;
    plot(SPower_AMI);
    xlim([0 length(SPower_AMI)])
end