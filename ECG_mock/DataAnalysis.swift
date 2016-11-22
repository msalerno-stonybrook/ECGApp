//
//  DataAnalysis.swift
//  ECG_mock
//
//  Created by Michael Salerno on 11/21/16.
//  Copyright © 2016 ___STREYLAB___. All rights reserved.
//

import Foundation
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

func IterativePeakFind (M: Double, S: Double, new: Int, avg: Double, dataSet: [Int], peaks: [Int]) -> (M2:Double, S2: Double, SD: Double, dataSet2: [Int], newPeaks: [Int], movingAverage: Double){
    
    // Variable initialization
    let initialPoints = dataSet.count
    var (newM, newS, newSD) = (0.0,0.0,0.0)
    var newDataSet = dataSet
    var newPeaks = peaks
    var newAvg = avg
    let threshold: Double = 5
    
    if initialPoints < 3000 { // Essentially ignores data for ~15 seconds
        (newM, newS, newSD) = IterativeSD(M: M, S: S, new: Double(new), number: initialPoints)
        newDataSet.append(new)
        newPeaks.append(0)
        newAvg = (newAvg * Double(initialPoints) + Double(new)) / Double(initialPoints + 1)
    } else { // Starts checking peaks within threshold limit
        (newM, newS, newSD) = IterativeSD(M: M, S: S, new: Double(new), number: initialPoints)
        newDataSet.append(new)
        newAvg = (newAvg * Double(initialPoints) + Double(new)) / Double(initialPoints + 1)
        if Double(new) > (newAvg + (newSD * threshold)) {
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
    if points < 2 { // Ignores first point
        verifiedPeaks = [0]
    } else { // Finds peaks
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
