function output_sequence = iqpsk(received_qpsk, number)

% get the needed results
output_sequence = zeros(number * 2, 1)

for iGroup = 1: 1: number
	if real(received_qpsk(iGroup)) > 0 && imag(received_qpsk(iGroup)) > 0 
		output_sequence(iGroup * 2 - 1: iGroup * 2) = [1 1];
	end
	if real(received_qpsk(iGroup)) <= 0 && imag(received_qpsk(iGroup)) > 0 
		output_sequence(iGroup * 2 - 1: iGroup * 2) = [0 1];
	end
	if real(received_qpsk(iGroup)) > 0 && imag(received_qpsk(iGroup)) <= 0 
		output_sequence(iGroup * 2 - 1: iGroup * 2) = [1 0];
	end
	if real(received_qpsk(iGroup)) <= 0 && imag(received_qpsk(iGroup)) <= 0 
		output_sequence(iGroup * 2 - 1: iGroup * 2) = [0 0];
	end
end

