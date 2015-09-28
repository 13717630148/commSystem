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
nDataset = 200; % the data should be round times of the carrier numbers 1705 for 
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

errorRateW = zeros(15, 1);
errorRate = zeros(15, 1);

for iSNR = 1: 1: 15
% at the receiving end of the ofdm
receive = conv(h, channelSymbol);
receive = awgn(receive, iSNR, 'measured');


coefficient = zeros(kCarriers, 1);
error = 0;
errorW = 0;
totalNumber = 0;
totalNumberW = 0;
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
    
    % without the training data 
    decodedData = qpskdemod(real(trueSymbol)', imag(trueSymbol)', 1, ...
        kCarriers, QPSKmode);
    originalData = data((iSets - 1) * QPSKmode * kCarriers + 1 : ...
            iSets * QPSKmode * kCarriers);
    [number,ratio] = biterr(decodedData, originalData);
    error = error + number;
    totalNumber = totalNumber + 2 * kCarriers;
    
    % with the training data
    trueSymbol = trueSymbol ./ coefficient;

    decodedData = qpskdemod(real(trueSymbol)', imag(trueSymbol)', 1, ...
        kCarriers, QPSKmode);
    originalData = data((iSets - 1) * QPSKmode * kCarriers + 1 : ...
            iSets * QPSKmode * kCarriers);
    [number,ratio] = biterr(decodedData, originalData);
    errorW = errorW + number;
    totalNumberW = totalNumberW + 2 * kCarriers;
end
errorRateW(iSNR) = errorW / totalNumberW;
errorRate(iSNR) = error / totalNumber;
end

semilogy(1:15, errorRate);
box on;
grid on;
hold on;
xlabel('The SNR')
ylabel('The BER in lognitude')

semilogy(1:15, errorRateW, 'r');
legend('Without the anti-multipath', 'With the anti-multipath')