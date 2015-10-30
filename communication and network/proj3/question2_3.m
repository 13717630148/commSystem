% ----------------------------------------------------------------------- %
% It is the project of modulation with carrier transmission.
%
% Written by Tingwu Wang, Tsinghua University, for the course project
% 29/10/2015
% ----------------------------------------------------------------------- %
clear; clc; close all;

overSampleRate = 100;
T = 1;
N = 100 + 1;  % the first one is set as the initial bit
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
send_a = sendOrigin .* cos(2 * pi * f * t + phi_0);  % the bpsk modulation
send_b = [zeros(1, overSampleRate) send_a(1: end - overSampleRate)];
send_c = send_a .* send_b;
figure
subplot(4,1,1)
plot(sendOrigin(1: 10 * overSampleRate)); ylim([-1.2 1.2])
subplot(4,1,2)
plot(1: 10 * overSampleRate, send_a(1: 10 * overSampleRate));
subplot(4,1,3)
plot(1: 10 * overSampleRate, send_b(1: 10 * overSampleRate));
subplot(4,1,4)
plot(1: 10 * overSampleRate, send_c(1: 10 * overSampleRate));
