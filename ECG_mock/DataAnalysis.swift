//: Playground - noun: a place where people can play

import UIKit

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

func IterativePeakFind (M: Double, S: Double, new: Int, avg: Double, dataSet: [Int], peaks: [Int]) -> (M2:Double, S2: Double, dataSet2: [Int], newPeaks: [Int], movingAverage: Double){
    
    // Variable initialization
    let initialPoints = dataSet.count
    var (newM, newS, newSD) = (0.0,0.0,0.0)
    var newDataSet = dataSet
    var newPeaks = peaks
    var newAvg = avg
    let threshold: Double = 5
    
    if initialPoints < 300 { // Essentially ignores data for ~15 seconds
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
    return (newM, newS, newDataSet, newPeaks, newAvg)
}

func PeakVerify (peaks: [Int], verifiedPeaks: [Int]) -> [Int] {
    let points = peaks.count
    var verified = verifiedPeaks
    if points < 2 { // Ignores first point
        verified.append(0)
    } else { // Finds peaks
        if peaks[points-2] < peaks[points-1] {
            verified.append(1)
        }
        else{
            verified.append(0)
        }
    }
    return verified
}


/* Steps for data creation
 
 1) Run "PacketGeneration"
 2) Loop through multiple calls of "IterativePeakFind" with all points created by "PacketGeneration"
 3) Request new packet
 4) Repeat */

func HeartRate(peaks: [Int]) -> Int {
    var length = peaks.count-1 // Number of points provided
    var testData = peaks // To prevent modification of data
    var rate: Int = 3
    var gaps = [Int]() // Initialize
    let points = testData.reduce(0,+)-3 // We throw out 1st value
    let interval = 5 // in miliseconds
    
    if length < 999 { // WAIT
        rate = 0;
    }
    else if points > 2 { // Calculates heart rate
        
        // Removes first "peak" marker, to give a clean window)
        var indx = (testData.index(of: 1)!) + 1
        rate = indx
        testData = [Int](testData[indx...length])
        length = testData.count-1
        
        for _ in 0...points {
            indx = (testData.index(of:1)!)+1
            rate = indx
            testData = [Int](testData[indx...length])
            length = testData.count-1
            gaps.append(indx)
        }
        let averageGap = gaps.reduce(0,+) / gaps.count
        rate = 60000 / (averageGap * interval)
    }
    else {
        rate = 1000
    }
    print(rate)
    return rate
}
