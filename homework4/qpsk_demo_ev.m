% qpsk_demo_ev.m
% Evaluation of  QPSK modulation and demodulation
%

clear all;clc
ml = 2;                                   % QPSK(ml=2),BPSK(ml=1)
nd = 1705*6;                              % Simulated data length

%************************ Data Generation *********************************

data = rand(1,nd*ml)>0.5;              % Random binary data stream generation

%************************ QPSK Modulation *********************************

[ich,qch] = qpskmod(data,1,nd,ml);     % QPSK modulation
kmod = 1/sqrt(2);                     
ich1 = ich.*kmod;
qch1 = qch.*kmod;

%*********************** Add AWGN ***************************************

snr = 10;
clear i;
ch1 = ich1+i*qch1;
ch2 = awgn(ch1,snr,'measured');
ich2 = real(ch2);
qch2 = imag(ch2);

%*********************** Plot Constellations ******************************

comdata1 = ich1 + i*qch1;              % Complex modulated data
comdata2 = ich2 + i*qch2;
scatterplot(comdata1)                  % Plotting signal constellations
title('Constellation before AWGN')
axis([-1 1 -1 1])
scatterplot(comdata2)                  
title('Constellation after AWGN')
axis([-1 1 -1 1])

%********************** QPSK Demodulation ********************************

demodata = qpskdemod(ich2,qch2,1,nd,ml);

%********************** Check Data ***************************************
delay = 0;
data = double(data);
[number,ratio] = biterr(demodata(delay+1:end),data(1:end-delay))

