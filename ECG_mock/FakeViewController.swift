//
//  FakeViewController.swift
//  ECG_mock
//
//  Created by Michael Salerno on 11/14/16.
//  Copyright © 2016 ___STREYLAB___. All rights reserved.
//

import UIKit

class FakeViewController: UIViewController, FakeDataSource {


    @IBOutlet weak var heartRate: UILabel!
    @IBOutlet weak var displayTimeLabel: UILabel!
    @IBOutlet weak var displayDataLabel: UILabel!
    @IBOutlet weak var fplotView: FakePlotView!
    
    
    var startTime = TimeInterval()
    var timer:Timer = Timer()
    var endTime: Date!
    var alarmTime: Date!
    
    var v: Int = 1
    
    // Begin heart rate analysis
    var data = [Int]()
    //data.reserveCapacity(1000)

    var rate = Int()
    var rate_track = [Int]()
    var m = Double()
    var s = Double()
    var avg = Double()
    var peaks = [Int]()
    var SD = Double()
    var verified = [Int]()
    var position: Int = 1
    var counter: Int = 1
    
    
    
    var dataStream = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fplotView.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func start(_ sender: Any) {
       alarmTime = Date()
        if (!timer.isValid) {
            let aSelector : Selector = #selector(FakeViewController.updateTime)
            timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = Date.timeIntervalSinceReferenceDate
        }
        
    }
    
    @IBAction func stop(_ sender: Any) {
       endTime = Date()
       timer.invalidate()
    }

    
    func updateTime() {
        let currentTime = Date.timeIntervalSinceReferenceDate
        
        //Find the difference between current time and start time.
        var elapsedTime: TimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        displayTimeLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
        
        var packet = [Int]()
        (packet: packet, index: position) = PacketGeneration(v: position)
        
        for i in 0...9 {
            var dataPoint = packet[i]
            (m, s, data, peaks, avg) = IterativePeakFind(M: m, S: s, new: dataPoint, avg: avg, dataSet: data, peaks: peaks)
            
            verified = PeakVerify(peaks: peaks, verifiedPeaks: verified)
            
            var testWindow = verified
            var testCase = peaks.count % 2000
            if testCase == 0 {
                var length = peaks.count-1
                var indx = length - 1999
                testWindow = [Int](verified[indx...length])
                rate = HeartRate(peaks: testWindow)
                rate_track.append(rate)
                counter = 0
                
            }
            
            /* if data.count > 2000 {
                data.removeFirst()
                peaks.removeFirst()
                verified.removeFirst()
            } */
            
            fplotView.setNeedsDisplay()
        }
        heartRate.text = "\(rate)"

}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


func dataYforWidth(_ width: Int) -> [Int] {
    print(data)
    return data
    //return dataStream
}

func heartrate() -> Int {
    return 64
}
}
