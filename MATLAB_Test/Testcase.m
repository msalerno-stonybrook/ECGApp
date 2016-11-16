    i = 1;
    M = 0;
    S = 0;
    average = 0;
    dataset = 0;
    peaks = 0;
    verified = 0;
    x = 1;
while i < 5000
    [testpacket, x] = PacketGen(x);
    i = i + 10;
    n = 1;
    while n < 11
        new = testpacket(n);
        [M, S, SD, dataset, peaks, average] = IterativePeakFind(M, S, new, average, dataset, peaks);
        verified = [verified PeakVerify(peaks)];
        n = n + 1;
    end
    n = 1;
end;