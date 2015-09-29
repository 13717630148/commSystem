function entropy = entropy_type1(x, M, s2)
%The information of single event, both continous and discrete.
%
% Function of this function is to calculate the entropy of a certain 
% variable, which might not have a expression and only numerical resutls
% are available
%
% Written by Tingwu Wang, Tsinghua University, for the course project
% 27/09/2015
prob = 0;
sym_prob = 1 / M;
coff1 = sqrt(2 * pi) * s2;
coff2 = 2 * s2 .^2;
for i_symbol = 0: 1: M - 1
    %prob = prob + sym_prob * normpdf(x, i_symbol, s2);
    prob = prob + sym_prob / coff1 * exp(-(x - i_symbol).^2 / coff2);
end

entropy = entropy_cal(prob);