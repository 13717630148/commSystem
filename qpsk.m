function qpskSignal = qpsk(inputSequence)

if (mod(length(inputSequence), 2) ~= 0)
    error('The Bit length must be the 2N!');
end
qpskSignal = zeros(length(inputSequence) / 2, 1);

for iGroup = 1: 1: length(inputSequence) / 2
    % processing each group
    subSequence = inputSequence(2 * iGroup - 1: 2 * iGroup);
    if subSequence(1) == 0 && subSequence(2) == 1
        qpskSignal(iGroup) = 1 * exp (j * 3 / 4 * pi);
    end
    if subSequence(1) == 1 && subSequence(2) == 1
        qpskSignal(iGroup) = 1 * exp (j * 1 / 4 * pi);
    end
    if subSequence(1) == 1 && subSequence(2) == 0
        qpskSignal(iGroup) = 1 * exp (-j * 1 / 4 * pi);
    end
    if subSequence(1) == 0 && subSequence(2) == 0
        qpskSignal(iGroup) = 1 * exp (-j * 3 / 4 * pi);
    end
end

end
