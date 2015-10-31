% ----------------------------------------------------------------------- %
% It is the project of modulation with carrier transmission.
%
% Written by Tingwu Wang, Tsinghua University, for the course project
% 29/10/2015
% ----------------------------------------------------------------------- %
clear; clc; close all;

overSampleRate = 100;
T = 1;
N = 100;
sampleRate = N * overSampleRate;

sourceGen = rand(1, N);
source = zeros(1, N);
source(sourceGen > 0.5) = 1;

t = 0: 1 / (N * overSampleRate) : T - 1 / (N * overSampleRate);
sendOrigin = zeros(1, N * overSampleRate);

for i = 1: 1: N
    sendOrigin(1 + (i - 1) * overSampleRate: i * overSampleRate) = ...
        2 * source(i) - 1;
end

f = N * 10;  % the carrier frequency
phi_0 = 0;
send = sendOrigin .* cos(2 * pi * f * t + phi_0);  % the bpsk modulation

figure
subplot(3,1,1)
stem(source(1:10))
subplot(3,1,2)
stem(sendOrigin(1: 10 * overSampleRate))
subplot(3,1,3)
plot(send(1: 10 * overSampleRate))

figure
w = 0: sampleRate/(length(t)-1): sampleRate;
plot(w, 1 / length(send) * abs(fft(send)) .^ 2);


% demodulation begins
x = send .* cos(2 * pi * f * t + phi_0);
lpf_1 = zeros(1, length(x)); lpf_1(1: 10) = 1;  % two low pass filter
lpf_2 = zeros(1, length(x)); lpf_2(1: 12) = 1;
figure
plot(x(1: 20 * overSampleRate))
title('The received x')
y1 = conv(x, lpf_1);
y1 = y1(1:length(x));
y2 = conv(x, lpf_2);
y2 = y2(1:length(x));

figure
subplot(2,1,1)
plot(y1(1: 20 * overSampleRate))
subplot(2,1,2)
plot(y2(1: 20 * overSampleRate))


figure
subplot(3,1,1); plot((1 + sign(y1(1: 10 * overSampleRate))) / 2);
ylim([-1.5 1.5]); title('Decoded from y1')
subplot(3,1,2); plot((1 + sign(y2(1: 10 * overSampleRate))) / 2);
ylim([-1.5 1.5]); title('Decoded from y2')
subplot(3,1,3); plot((1 + sign(sendOrigin(1: 10 * overSampleRate))) / 2);
ylim([-1.5 1.5]); title('original')
