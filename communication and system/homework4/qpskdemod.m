function [DemodData]=qpskdemod(IData,QData,NumCarrier,nd,ModOrder)
%
% Function to perform QPSK  demodulation
%
%****************** variables *************************
% IData :input Ich data
% QData :input Qch data
% DemodData: demodulated data (NumCarrier-by-nd*ModOrder matrix)
% NumCarrier   : Number of paralell channels
% nd : Number of data
% ModOrder : Number of modulation levels
% (QPSK ->2)
% *****************************************************

DemodData=zeros(NumCarrier,ModOrder*nd);
DemodData((1:NumCarrier),(1:ModOrder:ModOrder*nd-1))=IData((1:NumCarrier),(1:nd))>=0;
DemodData((1:NumCarrier),(2:ModOrder:ModOrder*nd))=QData((1:NumCarrier),(1:nd))>=0;

%******************** end of file ***************************
