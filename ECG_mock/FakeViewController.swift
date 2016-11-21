//
//  FakeViewController.swift
//  ECG_mock
//
//  Created by Michael Salerno on 11/14/16.
//  Copyright © 2016 ___STREYLAB___. All rights reserved.
//

import UIKit

class FakeViewController: UIViewController {


    @IBOutlet weak var displayTimeLabel: UILabel!
    @IBOutlet weak var displayDataLabel: UILabel!
    
    var startTime = TimeInterval()
    var timer:Timer = Timer()
    var endTime: Date!
    var alarmTime: Date!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func start(_ sender: Any) {
        alarmTime = Date()
        if (!timer.isValid) {
            let aSelector : Selector = #selector(FakeViewController.updateTime)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
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
        
        
        
        
        
        // Mike edit    ///////////////////////////////////////
        
       // var startTimeCounter = startTime
        //var currentTimeCounter = currentTime
        //var elapsedTimeCounter: TimeInterval = currentTimeCounter - startTimeCounter
        //if elapsedTimeCounter >= 5 {
          //  displayDataLabel.text = "\("Yes")"
            
       // }
        //else  {
          //  displayDataLabel.text = "\("No")"
       // }
        
        /////////////////////////////////////////////////////////////////////////////
    }
    
 
    // Mike edit    ///////////////////////////////////////
    
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
        
        displayDataLabel.text = "\(packet)"

        return packet
        
    }
    
    
 //   func PacketGroup(j: Int) -> [[UInt]] {
   //     var start1: Int = j
     //   var dataStream = [[UInt]]()
       // for _ in 1...10 {
         //   dataStream.append(PacketGeneration(v: start1))
           // start1 += 10
     //   }
     //   return dataStream
 //   }
    

    
    
    /////////////////////////////////////////////////////////////////////////////
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
