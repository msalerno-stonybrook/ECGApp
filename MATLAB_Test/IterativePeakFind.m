function [M, S, SD, dataset, peaks, average] = IterativePeakFind(M, S, new, average, dataset, peaks)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

initialpoints = length(dataset);

threshold = 5;

if initialpoints < 3000
    [M, S, SD] = IterativeSD(M, S, new, initialpoints);
    dataset = [dataset new];
    peaks = [peaks 0];
    average = ((average * initialpoints) + new) / (initialpoints + 1);
else
    [M, S, SD] = IterativeSD(M, S, new, initialpoints);
    dataset = [dataset new];
    average = ((average * initialpoints) + new) / (initialpoints + 1);
    if new > (average + (SD * threshold))
        peaks = [peaks 1];
    else
        peaks = [peaks 0];
    end
end
end