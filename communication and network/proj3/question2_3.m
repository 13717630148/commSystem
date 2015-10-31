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
t = 0: 1 / (N * overSampleRate) : T - 1 / (N * overSampleRate);

% generate the input source symbols
sourceGen = rand(1, N);
source = zeros(1, N); source(1) = 1;  % the initial state
source(sourceGen > 0.5) = 1;

% from the absolute code to relative code
sendRelative = zeros(1, N);
sendRelative(1) = 1;  % the initial state
for i = 2: 1: N
    sendRelative(i) = mod(source(i) + sendRelative(i - 1), 2);
end

sendOrigin = zeros(1, N * overSampleRate);
for i = 1: 1: N
    sendOrigin(1 + (i - 1) * overSampleRate: i * overSampleRate) = ...
        2 * sendRelative(i) - 1;
end

f = N * 10.25;  % the carrier frequency
phi_0 = 0;

send_a = sendOrigin .* cos(2 * pi * f * t + phi_0);  % the bpsk modulation
send_b = [zeros(1, overSampleRate) send_a(1: end - overSampleRate)];
send_c = send_a .* send_b;

lpf_1 = zeros(1, length(send_c)); lpf_1(1: 10) = 1;  % two low pass filter
y1 = conv(send_c, lpf_1);
y1 = y1(1:length(send_c));

% get the original code
receiveRelative = zeros(1, N);
receiveOrigin = zeros(1, N); receiveOrigin(1) = 1;
for i = 1: 1: N
    receiveRelative(i) = y1((i - 1) * overSampleRate + overSampleRate / 2);
end

receiveOrigin(receiveRelative > 0) = 0;
receiveOrigin(receiveRelative < 0) = 1;

figure
subplot(6,1,1)
stem(1: 10, source(1: 10));
subplot(6,1,2)
plot(1: 10 * overSampleRate, send_a(1: 10 * overSampleRate));
subplot(6,1,3)
plot(1: 10 * overSampleRate, send_b(1: 10 * overSampleRate));
subplot(6,1,4)
plot(1: 10 * overSampleRate, send_c(1: 10 * overSampleRate));
subplot(6,1,5)
plot(1: 10 * overSampleRate, y1(1: 10 * overSampleRate));
subplot(6,1,6)
stem(1: 10, receiveOrigin(1: 10));