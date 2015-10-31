% ----------------------------------------------------------------------- %
% It is the project of modulation with baseband waveform.
%
% Written by Tingwu Wang, Tsinghua University, for the course project
% 29/10/2015
% ----------------------------------------------------------------------- %

clear all; close all;
N = 1001;   % sample 1000 points, 1 is added as the initial source
T = 1;  % the time period is 1 s
sampleRate = 8;

pobability = rand(1,N);
source = zeros(1,N);

source(pobability>0.8) = 1;  % generate the source
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
subplot(2,1,1); stem(source(1:20));
title('The original code');
subplot(2,1,2); plot(t(1:160),AMI(1:160));
title('Result after sampled');


% The HDB3 code
zeroCounter = 0; odd_evenCounter=0;
HDB3 = zeros(1, sampleRate * N);
for k = 1 : 1: N
    if (source(k) == 0)
        if(zeroCounter == 3)  % now we have 3 zeros in a row
            send(k) = 1 - 2 * odd_evenCounter;
            zeroCounter = 0;
        else
            zeroCounter = zeroCounter + 1;
        end
    elseif(odd_evenCounter == 1)
        send(k) = 1;
        odd_evenCounter = 1 - odd_evenCounter;
        zeroCounter = 0;
    else
        send(k)= -1;
        odd_evenCounter= 1 - odd_evenCounter;
        zeroCounter = 0;
    end
    HDB3((k-1) * sampleRate + 3 : k * sampleRate - 2) = send(k);
end

figure;
subplot(2,1,1); plot(t(1:160),AMI(1:160));
title('The original AMI sampled');
subplot(2,1,2); plot(t(1:160),HDB3(1:160));
title('Result after HDB3 sampled'); 

% The mile code码
mile = zeros(1, sampleRate * N);
send = zeros(2, N); send(2, 1) = 1;  % now the code is doubled
mile(1 : 4) = 0; mile(5 : 8) = 1;
for k = 2 :1 : N
    if(source(k)==1)
        send(1, k) = send(2, k - 1);
        send(2, k) = -send(2, k - 1);
    elseif(source(k - 1) == 1)
        send(1, k) = send(2, k - 1);
        send(2, k) = send(2, k - 1);
    else
        send(1, k) = -send(2, k - 1);
        send(2, k) = -send(2, k - 1);
    end
    % the code should be then resample to 8 times
    mile((k - 1) * 8 + 1 : (k - 1) * 8 + 4) = send(1, k);
    mile((k - 1) * 8 + 5 :(k) * 8) = send(2, k);
end
figure;
subplot(2,1,1);
stem(source(1:20));
subplot(2,1,2);
plot(t(1:160),mile(1:160));
title('Result after mili sampled');ylim([-1.5 1.5])

figure; 
subplot(3,1,1);
SPower_AMI = 1 / length(AMI) * abs(fft(AMI)) .^ 2;
plot(SPower_AMI);


subplot(3,1,2);
SPOWER_HDB = 1 / length(HDB3) * abs(fft(HDB3)).^2;
plot(SPOWER_HDB);

subplot(3,1,3);
SPOWER_MILE = 1 / length(mile) * abs(fft(mile)).^2;
plot(SPOWER_MILE);

