function prob = prob_show(x, M, s2)
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

for i_symbol = 0: 1: M - 1
    prob = prob + sym_prob * normpdf(x, i_symbol, s2);
end