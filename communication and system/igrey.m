function sequence = igrey(input_sequence)

% check for validility
if mod(length(input_sequence), 4) ~=0
	exit
end

% process each group into the grey's 50 shadows
for iGroup = 1: 1: round(length(input_sequence) / 4)

group_sequence = input_sequence((iGroup - 1) * 4 + 1: (iGroup - 1) * 4 + 4);

testSymbol = [num2str(group_sequence(1)) num2str(group_sequence(2)) ...
	num2str(group_sequence(3)) num2str(group_sequence(4))];

switch testSymbol 
	case '0000' 
		group_sequence(:) = [0 0 0 0];
	case '0001' 
		group_sequence(:) = [0 0 0 1];
	case '0011' 
		group_sequence(:) = [0 0 1 0];
	case '0010' 
		group_sequence(:) = [0 0 1 1];
	case '0110' 
		group_sequence(:) = [0 1 0 0];
	case '0111' 
		group_sequence(:) = [0 1 0 1];
	case '0101' 
		group_sequence(:) = [0 1 1 0];
	case '0100' 
		group_sequence(:) = [0 1 1 1];
	case '1100' 
		group_sequence(:) = [1 0 0 0];
	case '1101' 
		group_sequence(:) = [1 0 0 1];
	case '1111' 
		group_sequence(:) = [1 0 1 0];
	case '1110' 
		group_sequence(:) = [1 0 1 1];
	case '1010' 
		group_sequence(:) = [1 1 0 0];
	case '1011' 
		group_sequence(:) = [1 1 0 1];
	case '1001' 
		group_sequence(:) = [1 1 1 0];
	case '1000' 
		group_sequence(:) = [1 1 1 1];
end

input_sequence((iGroup - 1) * 4 + 1: (iGroup - 1) * 4 + 4) = group_sequence;
sequence = input_sequence;
end
