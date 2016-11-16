function [rate] = HeartRate(verified)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

points = length(verified);

if points < 5000
    rate = 0;
else 
    testdata = verified((points-2000):points);
    sum(testdata)
    rate = sum(testdata)/(10/60);
end