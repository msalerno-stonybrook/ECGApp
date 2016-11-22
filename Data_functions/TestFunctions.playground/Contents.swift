import XCPlayground

func PacketGeneration(v: Int) -> [UInt] {
    var fake_ecg: [UInt] = [1035,
                            1035,
                            1041,
                            1041,
                            1041,
                            1046,
                            1057,
                            1068,
                            1078,
                            1084,
                            1089,
                            1089,
                            1089,
                            1094,
                            1105,
                            1116,
                            1126,
                            1143,
                            1164,
                            1175,
                            1180,
                            1180,
                            1196,
                            1223,
                            1250,
                            1266,
                            1287,
                            1309,
                            1335,
                            1357,
                            1378,
                            1410,
                            1448,
                            1475,
                            1485,
                            1512,
                            1533,
                            1555,
                            1582,
                            1608,
                            1630,
                            1646,
                            1646,
                            1651,
                            1651,
                            1646,
                            1619,
                            1582,
                            1555,
                            1528,
                            1496,
                            1453,
                            1410,
                            1384,
                            1362,
                            1325,
                            1287,
                            1266,
                            1234,
                            1218,
                            1201,
                            1169,
                            1148,
                            1132,
                            1126,
                            1126,
                            1121,
                            1121,
                            1116,
                            1116,
                            1116,
                            1116,
                            1110,
                            1110,
                            1105,
                            1094,
                            1094,
                            1094,
                            1100,
                            1105,
                            1105,
                            1110,
                            1110,
                            1100,
                            1100,
                            1105,
                            1105,
                            1105,
                            1105,
                            1105,
                            1094,
                            1089,
                            1089,
                            1089,
                            1078,
                            1078,
                            1073,
                            1073,
                            1073,
                            1068,
                            1062,
                            1057,
                            1057,
                            1046,
                            1052,
                            1057,
                            1057,
                            1052,
                            1046,
                            1046,
                            1035,
                            1035,
                            1041,
                            1041,
                            1035,
                            1035,
                            1035,
                            1041,
                            1041,
                            1041,
                            1041,
                            1041,
                            1035,
                            1035,
                            1030,
                            1030,
                            1035,
                            1035,
                            1035,
                            1030,
                            1030,
                            1030,
                            1030,
                            1030,
                            1030,
                            1035,
                            1035,
                            1030,
                            1035,
                            1035,
                            1025,
                            1025,
                            1025,
                            1025,
                            1035,
                            1035,
                            1035,
                            1035,
                            1035,
                            1030,
                            1030,
                            1035,
                            1041,
                            1041,
                            1041,
                            1041,
                            1041,
                            1041,
                            1035,
                            1035,
                            1041,
                            1052,
                            1078,
                            1089,
                            1089,
                            1089,
                            1084,
                            1105,
                            1132,
                            1169,
                            1185,
                            1185,
                            1185,
                            1185,
                            1180,
                            1175,
                            1148,
                            1110,
                            1084,
                            1068,
                            1062,
                            1057,
                            1035,
                            1035,
                            1025,
                            1030,
                            1030,
                            1025,
                            1025,
                            1014,
                            1014,
                            1014,
                            1019,
                            1014,
                            1003,
                            998,
                            1003,
                            1003,
                            998,
                            993,
                            918,
                            880,
                            902,
                            1110,
                            1496,
                            1999,
                            2583,
                            3129,
                            3531,
                            3595,
                            3161,
                            2272,
                            1303,
                            666,
                            500,
                            570,
                            666,
                            682,
                            661,
                            612,
                            607,
                            607,
                            607,
                            623,
                            612,
                            629,
                            682,
                            757,
                            827,
                            880,
                            918,
                            944,
                            982,
                            998,
                            1014,
                            1019,
                            1025,
                            1030,
                            1025,
                            1030,
                            1035]
    var start: Int = v
    var packet = [UInt]()
    for _ in 1...10 {
        packet.append(fake_ecg[start])
        start += 1
        if start > 240 {
            start = 0
        }
    }
    return packet
}

import Darwin

func IterativeSD (M: Double, S: Double, new: Double, number: Int) -> (M2:Double, S2: Double, SD: Double) {
    var newM = Double ()
    var newS = Double()
    var deviation = Double ()
    
    if number == 1
    {
        newM = new
        newS = 0
    } else {
        newM = M + (new - M) / Double(number)
        newS = S + (new - M) * (new - newM)
        let variance = newS / (Double(number) - 1)
        deviation = sqrt(variance)
    }
    
        return (newM, newS, deviation)
}

func IterativePeakFind (M: Double, S: Double, new: Double, avg: Double, dataSet: [Double], peaks: [Int]) -> (M2:Double, S2: Double, SD: Double, dataSet2: [Double], newPeaks: [Int], movingAverage: Double){
    
    // Variable initialization
    let initialPoints = dataSet.count
    var (newM, newS, newSD) = (0.0,0.0,0.0)
    var newDataSet = dataSet
    var newPeaks = peaks
    var newAvg = avg
    let threshold: Double = 2

    if initialPoints < 3000 { // Essentially ignores data for ~15 seconds
        (newM, newS, newSD) = IterativeSD(M: M, S: S, new: new, number: initialPoints)
        newDataSet.append(new)
        newPeaks.append(0)
        newAvg = (newAvg * Double(initialPoints) + new) / Double(initialPoints + 1)
    } else { // Starts checking peaks within threshold limit
        (newM, newS, newSD) = IterativeSD(M: M, S: S, new: new, number: initialPoints)
        newDataSet.append(new)
        newAvg = (newAvg * Double(initialPoints) + new) / Double(initialPoints + 1)
        if new > (newAvg + (newSD * threshold)) {
            newPeaks.append(1)
        } else {
            newPeaks.append(0)
        }
    }
    return (newM, newS, newSD, newDataSet, newPeaks, newAvg)
}

func PeakVerify (peaks: [Int]) -> [Int] {
    let points = peaks.count
    var verifiedPeaks = [Int]()
    
    if points < 2 {
        verifiedPeaks = [0]
    } else {
        if peaks[points-2] < peaks[points-1] {
            verifiedPeaks.append(1)
        }
    }
    return verifiedPeaks
}


/* Steps for data creation

 1) Run "PacketGeneration"
 2) Loop through multiple calls of "IterativePeakFind" with all points created by "PacketGeneration"
 3) Request new packet
 4) Repeat */


var A = [1,2,3,4,5,5,7]
var test: Int = A.index(of: 5)!



var C = A[(A.index(of: 5)!+1)...(A.count-1)]










A.index(of: 5)


A.remove(at: 0)

A

var B = A[1...(A.count-1)]

var x: Int = 2
var y: Int = 3
x/y




func HeartRate(peaks: [Int]) -> Int {
    let length = peaks.count // Number of points provided
    var rate = Int () // Initialize
    var testData = peaks // To prevent modification of data
    var gaps = [Int]() // Initialize
    let points = testData.reduce(0,+)-1 // We throw out 1st value
    let interval = 5 // in miliseconds
    
    if length < 5000 { // WAIT
        rate = 0;
    }
    else { // Calculates heart rate
        
        // Removes first "peak" marker, to give a clean window)
        testData = [Int](testData[(testData.index(of: 1)!+1)...(length-1)])
        
        // Start search
        for i in 0 ... points {
            let index: Int = testData.index(of: 1)!
            gaps[i] = index
            testData = [Int](testData[(testData.index(of: 1)!+1)...(length-1)])
            
        }
        let averageGap = gaps.reduce(0,+)/points // Average time elapsed per gap
        rate = 60000/(averageGap * interval) // Value in "Peaks"/minute
    }
    return rate
}



var copy: [Int] = [0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0]



HeartRate(peaks: copy)




