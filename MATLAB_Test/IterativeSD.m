function [M, S, SD] = IterativeSD(M, S, new, number)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

if number == 1
    M = new;
    S = 0;
    SD = 0;
else
    M = M + (new - M) / number;
    S = S + (new - M) * (new - M);
    variance = S / (number-1);
    SD = sqrt(variance);
end

