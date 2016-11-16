function [verified] = PeakVerify(peaks)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

points = length(peaks);

if points < 2
    verified = [0];
else
    if peaks(points-1) < peaks(points)
        verified = 1;
    else
        verified = 0;
    end
end
end