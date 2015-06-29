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
lCp = round(nCarriers * guardInterval(2));

% Data Generation
nDataset = 100; % the data should be round times of the carrier numbers 1705 for 
               % simplicity
nTraining = 1;
QPSKmode = 2; % 2 for qpsk, 1 for bpsk
data = rand(1, kCarriers * (nDataset + nTraining) * QPSKmode) > 0.5;
                                           
% QPSK Modulation, remember to normalize the data
[ich, qch] = qpskmod(data, 1, kCarriers * (nDataset + nTraining), QPSKmode);
ich = ich ./ sqrt(2);
qch = qch ./ sqrt(2);

% plot the input symbols
inputSymbol = ich + 1j * qch;              % Complex modulated data
%scatterplot(inputSymbol);

% the channel symbol with CP as guardian interval
channelSymbol = zeros((nCarriers + lCp) * (nDataset + nTraining), 1);

% from sequencial to parallel
for iSets = 1: 1: nDataset + nTraining
    tempSets = zeros(nCarriers, 1);
    tempSets(2:854, 1) = inputSymbol(1 + (iSets - 1) * kCarriers: ...
        1 + (iSets - 1) * kCarriers + 854 - 2);
    tempSets(1197:2048, 1) = inputSymbol(1 + (iSets - 1) * kCarriers + 854 ...
        - 2 + 1: iSets * kCarriers);

    % get the channel symbol, and add the cp
    channelSymbol(lCp + 1 + (iSets - 1) * (nCarriers + lCp): iSets * (nCarriers + lCp)) ...
        = ifft(tempSets);
    channelSymbol(1 + (iSets - 1) * (nCarriers + lCp): lCp + (iSets - 1) * (nCarriers + lCp)) = ...
        channelSymbol(iSets * (nCarriers + lCp) - lCp + 1: iSets * (nCarriers + lCp));
end
% freqPlot = fft(channelSymbol);

% channel parameters
n = round(1.8e-6 / TU * (nCarriers + lCp));
h = zeros(n, 1);
h(1) = 1;
h(n) = 10 ^ (-10 / 20);
% 
%  延时(us) 0
%  1.8
%  3.6
%  7.5
%  19.8
% 强度(dB) -20
%  0
%  -10
%  -14
%  -18
n = round(19.8e-6 / TU * (nCarriers + lCp));
h2 = zeros(n, 1);
h2(1) = 10 ^ (-20 / 20);
h2(round(1.8e-6 / TU * (nCarriers + lCp))) = 10 ^ (0 / 20);
h2(round(3.6e-6 / TU * (nCarriers + lCp))) = 10 ^ (-10 / 20);
h2(round(7.5e-6 / TU * (nCarriers + lCp))) = 10 ^ (-14 / 20);
h2(round(19.8e-6 / TU * (nCarriers + lCp))) = 10 ^ (-18 / 20);

for iSNR = 6: 1: 15
% at the receiving end of the ofdm
receive = conv(h2, channelSymbol);
receive = awgn(receive, iSNR, 'measured');


coefficient = zeros(kCarriers, 1);
error = 0;
totalNumber = 0;
for iSets = 1: 1: nDataset + nTraining

    tempSets = zeros(nCarriers, 1);
    tempSets(:) = receive((iSets - 1) * (nCarriers + lCp) + 1 + lCp: ...
        iSets * (nCarriers + lCp));
    receiveSymbol = fft(tempSets);

    
    trueSymbol = [receiveSymbol(2:854); receiveSymbol(1197:2048)];
    
    if iSets == 1
        coefficient = trueSymbol ./ conj(inputSymbol(1: length(trueSymbol)))';
        continue
    end
    
    trueSymbol = trueSymbol ./ coefficient;

    decodedData = qpskdemod(real(trueSymbol)', imag(trueSymbol)', 1, ...
        kCarriers, QPSKmode);
    originalData = data((iSets - 1) * QPSKmode * kCarriers + 1 : ...
            iSets * QPSKmode * kCarriers);
    [number,ratio] = biterr(decodedData, originalData);
    error = error + number;
    totalNumber = totalNumber + kCarriers;
end
errorRate = error / totalNumber
end