function [iout,qout]=qpskmod(ParaData,NumCarrier,nd,ModOrder)
%
% Function to perform QPSK modulation% 
%
%****************** variables *************************
% ParaData : input data (NumCarrier-by-nd*ModOrder matrix)
% iout :output Ich data
% qout :output Qch data
% NumCarrier   : Number of paralell channels
% nd : Number of data
% ModOrder : Number of modulation levels
% (QPSK ->2)
% *****************************************************

m2=ModOrder./2;

ParaData2=ParaData.*2-1;
count2=0;

for jj=1:nd

	isi = zeros(NumCarrier,1);
	isq = zeros(NumCarrier,1);

	for ii = 1 : m2 
  		isi = isi + 2.^( m2 - ii ) .* ParaData2((1:NumCarrier),ii+count2);
  		isq = isq + 2.^( m2 - ii ) .* ParaData2((1:NumCarrier),m2+ii+count2);
	end

	iout((1:NumCarrier),jj)=isi;
	qout((1:NumCarrier),jj)=isq;

	count2=count2+ModOrder;

end

%******************** end of file ***************************
