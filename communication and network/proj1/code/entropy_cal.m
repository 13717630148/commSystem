function sum = entropy_cal(x)
%The information of single event, both continous and discrete.
%
% Function of this function is to calculate the entropy of a certain 
% variable, which might not have a expression and only numerical resutls
% are available
%
% Written by Tingwu Wang, Tsinghua University, for the course project
% 27/09/2015
sum = - x .* log2(x);
sum(x == 0) = 0;

end
