% ----------------------------------------------------------------------- %
% It is the project of PCM: sampling, reconstructtion and error analyse.
%
% Written by Tingwu Wang, Tsinghua University, for the course project
% 14/10/2015
% ----------------------------------------------------------------------- %

fs = 10000;  % in the calculation, the sample rate should be 10000

real_world_fss = 100e3;  % the real world time slot is 100e3 in one second
T_period = 1;  % we only consider a time slot of 1s

source_power1 = 1;  % power of 10k - 11khz
source_power2 = 1e-6;  % power of 12 - 15khz

f1_low = 10e3;
f1_high = 11e3;
f2_low = 12e3;
f2_high = 15e3;

t = 0: T_period / real_world_fss: T_period;  % t is the time slot

% ------------------------ simulation begins ---------------------------- %
original_white_signal = rand(1, length(t))* 2 * sqrt(3);
f_original_white_signal = fft(original_white_signal);

% the signal received from the s1
mask_1 = zeros(1, length(t));
mask_1((t > f1_low / real_world_fss * T_period & ...
    t < f1_high / real_world_fss * T_period)) = 1;
mask_1((t > T_period - f1_high / real_world_fss * T_period & ...
    t < T_period - f1_low / real_world_fss * T_period)) = 1;

ffrs_1 = f_original_white_signal.* mask_1;
s1 = ifft(ffrs_1) * sqrt(real_world_fss / 2 / (f1_high - f1_low));
s1 = s1 * sqrt(source_power1);


% the signal received from the s1
mask_2 = zeros(1, length(t));
mask_2((t > f2_low / real_world_fss * T_period & ...
    t < f2_high / real_world_fss * T_period)) = 1;
mask_2((t > T_period - f2_high / real_world_fss * T_period & ...
    t < T_period - f2_low / real_world_fss * T_period)) = 1;

ffrs_2 = f_original_white_signal.* mask_2;
s2 = ifft(ffrs_2) * sqrt(real_world_fss / 2 / (f2_high - f2_low));
s2 = s2 * sqrt(source_power2);

% plot the received signal s = s1 + s2
s = real(s1 + s2);
plot(t, real(s)); title('The received time signal')  % origin time signal 


% ----------------------------------------------------------------------- %

t_sample = 0: 1 / fs : T_period;
sample_signal = downsample(s, real_world_fss / fs);

figure;
subplot(2, 1, 1);
plot(t_sample, real(sample_signal)); title('The sampled time signal');
subplot(2, 1, 2);
plot((0 : length(sample_signal) - 1) / length(sample_signal) * fs, ...
    (abs(fft(sample_signal) / sqrt(length(sample_signal) * T_period))));
title('The sampled signal spectrum');


% ----------------------------------------------------------------------- %
L = 64;
V = 4;
dV = 2 * V / L;

quan_signal = (floor(sample_signal / dV) + 0.5) * dV;

t_sample = 0: 1 / fs : T_period;

figure;
subplot(2, 1, 1);
plot(t_sample, real(quan_signal)); title('The quantilized time signal');
subplot(2, 1, 2);
plot((0 : length(quan_signal) - 1) / length(quan_signal) * fs, ...
    (abs(fft(quan_signal) / sqrt(length(quan_signal) * T_period))));
title('The quantilized sampled signal spectrum');


% ----------------------------------------------------------------------- %
Frequency = fft(quan_signal);
mask_sample = ones(1, length(quan_signal));
mask_sample(t_sample < (f2_low - fs) / fs & ...
    t_sample > (f1_high - fs) / length(quan_signal)) = 0;
temp_mask = mask_sample(end : -1: 1);
mask_sample = min(mask_sample, temp_mask);

qs_recovered = ifft(Frequency .* mask_sample);

figure;
subplot(2,1,1);
plot(t_sample, qs_recovered); title('The recovered sample signal');
subplot(2,1,2);
plot((0 : length(sample_signal) - 1) / length(sample_signal) * fs, ...
    abs(Frequency .* mask_sample)); title('The recovered signal spectrum');


% ----------------------------------------------------------------------- %

error= quan_signal - qs_recovered;
figure;
subplot(2,1,1);
plot(t_sample, error); title('The reconstruction error')
subplot(2,1,2);
plot((0 : length(sample_signal) - 1) / length(sample_signal) * fs, ...
    abs(fft(error))); title('The reconstruction error spectrum');
