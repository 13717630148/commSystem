% ----------------------------------------------------------------------------
% Written by Tingwu Wang, Tsinghua University
% Homework 4 for the Course Communication System
%
% 2015.6.29
% ----------------------------------------------------------------------------

% the initial of parameters
TU = 224e-6; % us, the time of the symbol
kCarriers = 1705;
nCarriers = 2048;
bandWidth = 7.61e6; % Hz as the band width
guardInterval = [1/4 1/8 1/16 1/32];

% Data Generation
nDataset = 10; % the data should be round times of the carrier numbers 1705 for 
               % simplicity
nTraining = 1;
QPSKmode = 2; % 2 for qpsk, 1 for bpsk
data = rand(1, kCarriers * (nDataset + nTraining) * QPSKmode) > 0.5;
                                           
% QPSK Modulation, remember to normalize the data
[ich, qch] = qpskmod(data, 1, kCarriers * (nDataset + nTraining), QPSKmode);
ich = ich ./ sqrt(2);
qch = qch ./ sqrt(2);

% plot the input symbols
inputSymbol = ich + 1j*qch;              % Complex modulated data
%scatterplot(inputSymbol);

% the channel symbol with CP as guardian interval
lCp = round(nCarriers * guardInterval(2));
channelSymbol = zeros(length(inputSymbol) + lCp * (nDataset + nTraining), 1);

% from sequencial to parallel
for iSets = 1: 1: nDataset + nTraining
    tempSets = zeros(nCarriers, 1);
    tempSets(2:854, 1) = inputSymbol(1 + (iSets - 1) * kCarriers: ...
        1 + (iSets - 1) * kCarriers + 854 - 2);
    tempSets(1197:2048, 1) = inputSymbol(1 + (iSets - 1) * kCarriers + 854 ...
        - 2 + 1: iSets * kCarriers);

    % get the channel symbol, and add the cp
    channelSymbol(lCp + 1 + (iSets - 1) * nCarriers: lCp + iSets * nCarriers) ...
        = ifft(tempSets);
    channelSymbol(1: lCp) = channelSymbol(end - lCp + 1, end);
end
figure(1)
plot(real(channelSymbol));
figure(2)
freqPlot = fft(channelSymbol);
plot(real(freqPlot));
%scatterplot(channelSymbol)


